package com.vacs.gnsa

import android.device.PrinterManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat   
import java.util.Date

class MainActivity : FlutterActivity() {
    private var printerManager: PrinterManager? = null
    private val CHANNEL = "urovo_printer"
    private val PAGE_WIDTH = 384 // Thiết kế cho 48mm, 203 dpi
    private val TAG = "MainActivity"
    private var isPrinterDevice = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        try {
            printerManager = PrinterManager()
            printerManager?.open()
            isPrinterDevice = true
            Log.d(TAG, "Đây là thiết bị máy in. Máy in được khởi tạo thành công.")
        } catch (e: Exception) {
            isPrinterDevice = false
            Log.w(TAG, "Đây không phải thiết bị máy in: ${e.message}")
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (isPrinterDevice) {
                    when (call.method) {
                        "printGnsa" -> {
                            val data = call.arguments as? Map<String, Any>
                            val flightData = data?.get("data") as? Map<String, Any>
                            if (flightData != null) {
                                printFlightDetail(flightData)
                                result.success("Chi tiết chuyến bay đã được in thành công")
                            } else {
                                Log.e(TAG, "Dữ liệu không hợp lệ: Không có dữ liệu chuyến bay")
                                result.error("INVALID_DATA", "Không có dữ liệu chuyến bay", null)
                            }
                        }
                        "printText" -> {
                            val args = call.arguments as? Map<String, Any>
                            val text = args?.get("text") as? String ?: ""
                            printSimpleText(text)
                            result.success("Văn bản đã được in thành công")
                        }
                        "printImage" -> {
                            val args = call.arguments as? Map<String, Any>
                            val assetPath = args?.get("assetPath") as? String ?: ""
                            printImageFromAsset(assetPath)
                            result.success("Hình ảnh đã được in thành công")
                        }
                        "printPreview" -> {
                            val args = call.arguments as? Map<String, Any>
                            val data = args?.get("data") as? Map<String, Any>
                            if (data != null) {
                                printPreviewData(data)
                                result.success("Dữ liệu xem trước đã được in thành công")
                            } else {
                                Log.e(TAG, "Dữ liệu không hợp lệ: Không có dữ liệu xem trước")
                                result.error("INVALID_DATA", "Không có dữ liệu xem trước", null)
                            }
                        }
                        "checkPrinterStatus" -> {
                            val status = printerManager?.status
                            result.success("Trạng thái máy in: $status")
                        }
                        else -> {
                            Log.w(TAG, "Phương thức chưa được triển khai: ${call.method}")
                            result.notImplemented()
                        }
                    }
                } else {
                    when (call.method) {
                        "printGnsa" -> {
                            Log.w(TAG, "Lệnh in bị bỏ qua: Không phải thiết bị máy in")
                            result.success("Không có máy in trên thiết bị này")
                        }
                        "printText" -> {
                            Log.w(TAG, "Lệnh in văn bản bị bỏ qua: Không phải thiết bị máy in")
                            result.success("Không có máy in trên thiết bị này")
                        }
                        "printImage" -> {
                            Log.w(TAG, "Lệnh in hình ảnh bị bỏ qua: Không phải thiết bị máy in")
                            result.success("Không có máy in trên thiết bị này")
                        }
                        "printPreview" -> {
                            Log.w(TAG, "Lệnh in xem trước bị bỏ qua: Không phải thiết bị máy in")
                            result.success("Không có máy in trên thiết bị này")
                        }
                        "checkPrinterStatus" -> result.success("Không có máy in")
                        else -> {
                            Log.w(TAG, "Phương thức chưa được triển khai hoặc bị bỏ qua: ${call.method}")
                            result.notImplemented()
                        }
                    }
                }
            }
    }

    private fun printFlightDetail(data: Map<String, Any>) {
        if (!isPrinterDevice) {
            Log.w(TAG, "Không thể in: Không phải thiết bị máy in")
            return
        }

        try {
            // Log the received data for debugging
            Log.d(TAG, "Received data for flight detail printing: $data")
            val flightInfo = data["FlightInfo"]
            Log.d(TAG, "FlightInfo data in flight detail: $flightInfo")
            val supplyFormDetails = data["SupplyFormDetails"]
            Log.d(TAG, "SupplyFormDetails data in flight detail: $supplyFormDetails")
            val qrBytes = data["QRCode"] as? ByteArray
            
            val status = printerManager?.status
            Log.d(TAG, "Trạng thái máy in: $status")
            if (status == PrinterManager.PRNSTS_OK) {
                Log.d(TAG, "Máy in sẵn sàng. Bắt đầu công việc in.")
                printerManager?.setupPage(PAGE_WIDTH, -1)
                var yPosition = 0

                yPosition = printLogo(yPosition)
                yPosition = printFlightInfo(data, yPosition)
                yPosition = printDivider(yPosition)
                yPosition = printSupplyForms(data, yPosition)
                yPosition = printQR(qrBytes,yPosition)
                printerManager?.printPage(0)
                printerManager?.paperFeed(140)
                Log.d(TAG, "Công việc in hoàn tất thành công.")
            } else {
                Log.e(TAG, "Máy in không sẵn sàng. Trạng thái: $status")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi trong quá trình in: ${e.message}", e)
        }
    }

    private fun printSimpleText(text: String) {
        if (!isPrinterDevice) {
            Log.w(TAG, "Không thể in: Không phải thiết bị máy in")
            return
        }

        try {
            val status = printerManager?.status
            Log.d(TAG, "Trạng thái máy in: $status")
            if (status == PrinterManager.PRNSTS_OK) {
                Log.d(TAG, "Máy in sẵn sàng. Bắt đầu in văn bản.")
                printerManager?.setupPage(PAGE_WIDTH, -1)
                
                // Print the text
                printerManager?.drawText(text, 0, 0, "simsun", 24, false, false, 0)
                
                printerManager?.printPage(0)
                printerManager?.paperFeed(100)
                Log.d(TAG, "In văn bản hoàn tất thành công.")
            } else {
                Log.e(TAG, "Máy in không sẵn sàng. Trạng thái: $status")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi trong quá trình in văn bản: ${e.message}", e)
        }
    }

    private fun printImageFromAsset(assetPath: String) {
        if (!isPrinterDevice) {
            Log.w(TAG, "Không thể in: Không phải thiết bị máy in")
            return
        }

        try {
            val status = printerManager?.status
            Log.d(TAG, "Trạng thái máy in: $status")
            if (status == PrinterManager.PRNSTS_OK) {
                Log.d(TAG, "Máy in sẵn sàng. Bắt đầu in hình ảnh.")
                printerManager?.setupPage(PAGE_WIDTH, -1)
                
                // For now, we'll print a simple message since we don't have asset loading implemented
                printerManager?.drawText("Hình ảnh: $assetPath", 0, 0, "simsun", 24, false, false, 0)
                
                printerManager?.printPage(0)
                printerManager?.paperFeed(100)
                Log.d(TAG, "In hình ảnh hoàn tất thành công.")
            } else {
                Log.e(TAG, "Máy in không sẵn sàng. Trạng thái: $status")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi trong quá trình in hình ảnh: ${e.message}", e)
        }
    }

    private fun printPreviewData(data: Map<String, Any>) {
        if (!isPrinterDevice) {
            Log.w(TAG, "Không thể in: Không phải thiết bị máy in")
            return
        }

        try {
            // Log the received data for debugging
            Log.d(TAG, "Received data for printing: $data")
            val flightInfo = data["FlightInfo"]
            Log.d(TAG, "FlightInfo data: $flightInfo")
            val supplyFormDetails = data["SupplyFormDetails"]
            Log.d(TAG, "SupplyFormDetails data: $supplyFormDetails")
            val qrBytes = data["QRCode"] as? ByteArray

            val status = printerManager?.status
            Log.d(TAG, "Trạng thái máy in: $status")
            if (status == PrinterManager.PRNSTS_OK) {
                Log.d(TAG, "Máy in sẵn sàng. Bắt đầu in dữ liệu xem trước.")
                printerManager?.setupPage(PAGE_WIDTH, -1)
                var yPosition = 0

                // Print logo first
                yPosition = printLogo(yPosition)
                
                // Print flight info header section
                yPosition = printPreviewFlightInfo(data, yPosition)
                
                // Print divider to match UI
                yPosition = printDivider(yPosition)
                
                // Print supply forms
                yPosition = printPreviewSupplyForms(data, yPosition)
                
                // Print thank you message
                yPosition = printQR(qrBytes, yPosition)
                
                printerManager?.printPage(0)
                printerManager?.paperFeed(140)
                Log.d(TAG, "In dữ liệu xem trước hoàn tất thành công.")
            } else {
                Log.e(TAG, "Máy in không sẵn sàng. Trạng thái: $status")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi trong quá trình in dữ liệu xem trước: ${e.message}", e)
        }
    }

    private fun printLogo(startY: Int): Int {
        var yPosition = startY
        try {
            val bitmap = BitmapFactory.decodeResource(resources, R.drawable.logoprint)
            if (bitmap != null) {
                Log.d(TAG, "Ảnh logo được tải thành công.")
                val bwBitmap = convertToBlackAndWhite(bitmap)
                // Scale the logo to be more proportional (smaller than before)
                val scaledBitmap = Bitmap.createScaledBitmap(bwBitmap, 150, 60, true)
                val logoX = (PAGE_WIDTH - scaledBitmap.width) / 2  // Center the logo
                printerManager?.drawBitmap(scaledBitmap, logoX.coerceAtLeast(0), yPosition)
                yPosition += scaledBitmap.height + 16  // Increased spacing after logo for better visual separation
                Log.d(TAG, "Logo được in tại yPosition: $yPosition")
            } else {
                Log.w(TAG, "Ảnh logo bị null. Bỏ qua việc in logo.")
                // Even if no logo, add some spacing
                yPosition += 20
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in logo: ${e.message}", e)
            // Add some spacing even if logo fails
            yPosition += 20
        }
        return yPosition
    }

    private fun convertToBlackAndWhite(bitmap: Bitmap): Bitmap {
        val width = bitmap.width
        val height = bitmap.height
        val bwBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565)

        for (x in 0 until width) {
            for (y in 0 until height) {
                val pixel = bitmap.getPixel(x, y)
                val gray = ((pixel shr 16 and 0xff) * 0.3 +
                        (pixel shr 8 and 0xff) * 0.59 +
                        (pixel and 0xff) * 0.11).toInt()
                val newPixel = if (gray < 128) 0xFF000000.toInt() else 0xFFFFFFFF.toInt()
                bwBitmap.setPixel(x, y, newPixel)
            }
        }
        return bwBitmap
    }


    private fun printPreviewFlightInfo(data: Map<String, Any>, startY: Int): Int {
        var yPosition = startY
        val lineHeight = 24

        try {
            val flightInfo = data["FlightInfo"] as? Map<String, Any>
            Log.d(TAG, "Extracted flightInfo: $flightInfo")
            val flightNo = flightInfo?.get("FlightNo") as? String ?: "N/A"
            val routing = flightInfo?.get("Routing") as? String ?: "N/A"
            val acfNo = flightInfo?.get("AcfNo") as? String ?: "N/A"
            val typeApl = flightInfo?.get("TypeApl") as? String ?: "N/A"
            val departureDate = flightInfo?.get("DepartureDate") as? String ?: ""
            val arrivalDate = flightInfo?.get("ArrivalDate") as? String ?: ""
            
            // Log extracted values
            Log.d(TAG, "Extracted flight data - FlightNo: $flightNo, Routing: $routing, AcfNo: $acfNo, TypeApl: $typeApl")

            // Header text - "Vietnam Airlines Caterers"
            val headerText = "Vietnam Airlines Caterers"
            val headerX = (PAGE_WIDTH - headerText.length * 8) / 2
            printerManager?.drawText(headerText, headerX.coerceAtLeast(0), yPosition, "simsun", 16, true, false, 0)
            yPosition += lineHeight

            // Address text
            val addressLine1 = "Tan Son Nhat International Airport, Tan Son Hoa Ward,"
            val addressLine2 = "Ho Chi Minh City, Vietnam."
            val addressX1 = (PAGE_WIDTH - addressLine1.length * 6) / 2
            val addressX2 = (PAGE_WIDTH - addressLine2.length * 6) / 2
            printerManager?.drawText(addressLine1, addressX1.coerceAtLeast(0), yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight - 4
            printerManager?.drawText(addressLine2, addressX2.coerceAtLeast(0), yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight - 4

            // Phone number
            val phone = "(84 - 28) 38.448.367"
            val phoneX = (PAGE_WIDTH - phone.length * 6) / 2
            printerManager?.drawText(phone, phoneX.coerceAtLeast(0), yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight + 4

            // Divider
            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight + 4

            // Title
            val title = "Delivery and Receipt Note"
            val titleX = (PAGE_WIDTH - title.length * 6) / 3
            printerManager?.drawText(title, titleX.coerceAtLeast(0), yPosition, "simsun", 20, true, false, 0)
            yPosition += lineHeight + 4

            // Code
            val acfNoText = acfNo ?: ""
            val codeText = "Code: $acfNoText"
            val codeX = (PAGE_WIDTH - codeText.length * 6) / 3
            printerManager?.drawText(codeText, codeX.coerceAtLeast(0), yPosition, "simsun", 16, true, false, 0)
            yPosition += lineHeight + 8

            // Divider
            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight + 4



            // Flight details - Row 1: Flight and Flight No (side by side)
            printerManager?.drawText("Flight: $routing".take(24), 0, yPosition, "simsun", 14, false, false, 0)
            printerManager?.drawText("PK: $typeApl".take(24), PAGE_WIDTH/2, yPosition, "simsun", 14, false, false, 0)
            yPosition += lineHeight

            // Flight details - Row 2: PK and A/C (side by side)
            printerManager?.drawText("Flight No: $flightNo".take(24), 0, yPosition, "simsun", 14, false, false, 0)
            printerManager?.drawText("A/C: $acfNo".take(24), PAGE_WIDTH/2, yPosition, "simsun", 14, false, false, 0)
            yPosition += lineHeight

            // Additional flight info - Departure
            if (departureDate.isNotEmpty()) {
                printerManager?.drawText("Departure: ${formatDate(departureDate)}".take(48), 0, yPosition, "simsun", 14, false, false, 0)
                yPosition += lineHeight
            }
            
            // Additional flight info - Arrival
            if (arrivalDate.isNotEmpty()) {
                printerManager?.drawText("Arrival: ${formatDate(arrivalDate)}".take(48), 0, yPosition, "simsun", 14, false, false, 0)
                yPosition += lineHeight
            }

            // Divider
            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight + 4

            // Table header
            printerManager?.drawText("Name".take(24), 0, yPosition, "simsun", 14, true, false, 0)
            printerManager?.drawText("Qty".take(24), PAGE_WIDTH - 12*6, yPosition, "simsun", 14, true, false, 0)
            yPosition += lineHeight

            // Divider under table header
            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 12, false, false, 0)
            yPosition += lineHeight

            Log.d(TAG, "Thông tin chuyến bay được in tại yPosition: $yPosition")
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in thông tin chuyến bay: ${e.message}", e)
        }
        return yPosition
    }

    // Helper function to format date
    private fun formatDate(dateString: String): String {
        return try {
            // Assuming the date format is "yyyy-MM-ddTHH:mm:ss"
            if (dateString.contains("T")) {
                val parts = dateString.split("T")
                if (parts.size > 1) {
                    val datePart = parts[0]
                    val timePart = parts[1].substring(0, 5) // Get HH:mm
                    "$datePart $timePart"
                } else {
                    dateString
                }
            } else {
                dateString
            }
        } catch (e: Exception) {
            dateString
        }
    }

    private fun printDivider(startY: Int): Int {
        val yPosition = startY
        try {
            val divider = "---------------------------------------------------".take(48)
            printerManager?.drawText(divider, 0, yPosition, "simsun", 14, false, false, 0)
            Log.d(TAG, "Dòng phân cách được in tại yPosition: ${yPosition + 24}")
            return yPosition + 24
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in dòng phân cách: ${e.message}", e)
            return yPosition
        }
    }
    
    private fun printFlightInfo(data: Map<String, Any>, startY: Int): Int {
        // For now, we'll use the same implementation as printPreviewFlightInfo
        // In a more complete implementation, this might have different formatting
        return printPreviewFlightInfo(data, startY)
    }
    
    private fun printSupplyForms(data: Map<String, Any>, startY: Int): Int {
        // For now, we'll use the same implementation as printPreviewSupplyForms
        // In a more complete implementation, this might have different formatting
        return printPreviewSupplyForms(data, startY)
    }
    
    private fun printPreviewSupplyForms(data: Map<String, Any>, startY: Int): Int {
        var yPosition = startY
        val lineHeight = 26
        val smallLineHeight = 24

        try {
            val supplyFormDetails = data["SupplyFormDetails"] as? List<Map<String, Any>>
            Log.d(TAG, "Extracted supplyFormDetails: $supplyFormDetails")
            
            supplyFormDetails?.forEachIndexed { index, form ->
                val supplyType = form["SupplyType"] as? String ?: "N/A"
                val supplyCode = form["SupplyCode"] as? String ?: "N/A"
                val detailItems = form["DetailItems"] as? List<Map<String, Any>>
                
                // Log extracted values
                Log.d(TAG, "Supply form $index - Type: $supplyType, Code: $supplyCode")
                Log.d(TAG, "Detail items for form $index: $detailItems")

                // Supply form header
                printerManager?.drawText("$supplyType".take(48), 0, yPosition, "simsun", 16, true, false, 0)
                printerManager?.drawText(supplyCode.toString().take(48), PAGE_WIDTH - 12*6, yPosition, "simsun", 14, false, false, 0)

                yPosition += lineHeight + 4

                // Detail items
                detailItems?.forEach { item ->
                    val itemName = item["ItemName"] as? String ?: "N/A"
                    val quantity = item["Quantity"] as? Int ?: 0
                    printerManager?.drawText(itemName.take(36), 0, yPosition, "simsun", 14, false, false, 0)
                    printerManager?.drawText(quantity.toString().take(12), PAGE_WIDTH - 12*6, yPosition, "simsun", 14, false, false, 0)
                    yPosition += smallLineHeight
                }

                // Add spacing before dashed line
                yPosition += 4

                // Dashed line separator (simulated with dotted line)
                val dashLine = "---------------------------------------------------"
                printerManager?.drawText(dashLine.take(48), 0, yPosition, "simsun", 12, false, false, 0)
                yPosition += lineHeight + 4
            }

            // Add some spacing before Total
            yPosition += 8

            // Total
            val totalSupply = data["TotalSupply"] as? Int ?: 0
            Log.d(TAG, "Total supply: $totalSupply")
            printerManager?.drawText("Total:".take(24), 0, yPosition, "simsun", 16, true, false, 0)
            printerManager?.drawText(totalSupply.toString().take(24), PAGE_WIDTH - 12*6, yPosition, "simsun", 16, true, false, 0)
            yPosition += lineHeight + 8

            Log.d(TAG, "Biểu mẫu cung cấp được in tại yPosition: $yPosition")
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in biểu mẫu cung cấp: ${e.message}", e)
        }
        return yPosition
    }

    private fun printQR(qrCode: ByteArray?, startY: Int): Int {
         if (qrCode == null) {
        Log.w(TAG, "QR code is null, skip printing")
        return startY
    }
        var yPosition = startY
        try {
            // Tiêu đề QR
            val qrTitleText = "Scan the QR code to view supply details"
            val qrTitleX = (PAGE_WIDTH - qrTitleText.length * 8) / 2
            printerManager?.drawText(qrTitleText, qrTitleX.coerceAtLeast(0), yPosition, "simsun", 16, true, false, 0)
            yPosition += 28

            // In QR code
            val bitmap = BitmapFactory.decodeByteArray(qrCode, 0, qrCode.size)
            val bwBitmap = convertToBlackAndWhite(bitmap) 
            val qrX = (PAGE_WIDTH - bwBitmap.width) / 2
            printerManager?.drawBitmap(bwBitmap, qrX.coerceAtLeast(0), yPosition)
            yPosition += bwBitmap.height + 20
            Log.d(TAG, "QR code printed at yPosition: $yPosition")

            // Text xác nhận
            val signedText = "Signed/Confirmed before printing"
            val signedX = (PAGE_WIDTH - signedText.length * 8) / 2
            printerManager?.drawText(signedText, signedX.coerceAtLeast(0), yPosition, "simsun", 16, true, false, 0)
            yPosition += 28

            // Thời gian in
            val currentTime = SimpleDateFormat("dd/MM/yyyy HH:mm").format(Date())
            val printedText = "     Printed: $currentTime"
            val printedX = (PAGE_WIDTH - printedText.length * 6) / 2
            printerManager?.drawText(printedText, printedX.coerceAtLeast(0), yPosition, "simsun", 12, false, false, 0)
            yPosition += 24

            Log.d(TAG, "QR + text printed at yPosition: $yPosition")
            return yPosition
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in QR: ${e.message}", e)
            return yPosition
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        if (isPrinterDevice) {
            try {
                printerManager?.close()
                Log.d(TAG, "Máy in đã được đóng thành công.")
            } catch (e: Exception) {
                Log.e(TAG, "Lỗi khi đóng máy in: ${e.message}", e)
            }
        }
    }
}