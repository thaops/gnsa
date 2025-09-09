package com.vacs.gnsa

import android.device.PrinterManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.Rect
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

    /**
     * Prints Unicode text by rendering it to a bitmap first
     * This ensures proper Vietnamese character support
     */
    private fun printUnicodeText(text: String, x: Int, y: Int, textSize: Float, isBold: Boolean = false, isCentered: Boolean = false): Int {
        try {
            // Create a bitmap to draw the text on
            val paint = Paint()
            paint.isAntiAlias = true
            paint.textSize = textSize
            
            // Try to load a Unicode font that supports Vietnamese
            try {
                val font = Typeface.createFromAsset(assets, "fonts/Roboto-Regular.ttf")
                paint.typeface = if (isBold) Typeface.create(font, Typeface.BOLD) else font
            } catch (e: Exception) {
                // Fallback to default font if custom font fails
                paint.typeface = if (isBold) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
                Log.w(TAG, "Could not load custom font, using default: ${e.message}")
            }
            
            // Measure text dimensions
            val bounds = Rect()
            paint.getTextBounds(text, 0, text.length, bounds)
            
            // Create bitmap with appropriate size
            val bitmapWidth = if (isCentered) PAGE_WIDTH else bounds.width() + 20
            val bitmapHeight = bounds.height() + 20
            val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.RGB_565)
            val canvas = Canvas(bitmap)
            
            // Fill background with white
            canvas.drawColor(0xFFFFFFFF.toInt())
            
            // Calculate position
            val textX = if (isCentered) (bitmapWidth - bounds.width()) / 2f else 10f
            val textY = bitmapHeight - 10f
            
            // Draw text
            paint.color = 0xFF000000.toInt() // Black text
            canvas.drawText(text, textX, textY, paint)
            
            // Convert to black and white for thermal printing
            val bwBitmap = convertToGray(bitmap)
            
            // Calculate final position
            val finalX = if (isCentered) 0 else x
            printerManager?.drawBitmap(bwBitmap, finalX, y)
            
            return y + bitmapHeight
        } catch (e: Exception) {
            Log.e(TAG, "Error printing Unicode text: ${e.message}", e)
            // Fallback to regular text printing if bitmap method fails
            printerManager?.drawText(text, x, y, "simsun", textSize.toInt(), isBold, false, 0)
            return y + textSize.toInt() + 10
        }
    }

    /**
     * Prints a line of Unicode text with proper line height calculation
     */
    private fun printUnicodeTextLine(text: String, startY: Int, textSize: Float = 24f, isBold: Boolean = false, isCentered: Boolean = false): Int {
        val lineHeight = (textSize * 1.5).toInt()
        val nextY = printUnicodeText(text, 0, startY, textSize, isBold, isCentered)
        return nextY
    }


    /**
     * Prints a row with two columns of Unicode text
     */
    private fun printUnicodeTextRow(leftText: String, rightText: String, startY: Int, textSize: Float = 24f, isBold: Boolean = false): Int {
        try {
            val lineHeight = (textSize * 1.5).toInt()
            
            // Create bitmap for the entire row
            val bitmap = Bitmap.createBitmap(PAGE_WIDTH, lineHeight, Bitmap.Config.RGB_565)
            val canvas = Canvas(bitmap)
            canvas.drawColor(0xFFFFFFFF.toInt())
            
            val paint = Paint()
            paint.isAntiAlias = true
            paint.textSize = textSize
            paint.color = 0xFF000000.toInt()
            
            // Try to load a Unicode font that supports Vietnamese
            try {
                val font = Typeface.createFromAsset(assets, "fonts/Roboto-Regular.ttf")
                paint.typeface = if (isBold) Typeface.create(font, Typeface.BOLD) else font
            } catch (e: Exception) {
                paint.typeface = if (isBold) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
                Log.w(TAG, "Could not load custom font for row, using default: ${e.message}")
            }
            
            // Draw left text
            val leftBounds = Rect()
            paint.getTextBounds(leftText, 0, leftText.length, leftBounds)
            canvas.drawText(leftText, 0f, lineHeight - 5f, paint)
            
            // Draw right text
            val rightBounds = Rect()
            paint.getTextBounds(rightText, 0, rightText.length, rightBounds)
            val rightX = (PAGE_WIDTH - rightBounds.width() - 10).toFloat()
            canvas.drawText(rightText, rightX, lineHeight - 5f, paint)
            
            // Convert to black and white and print
            val bwBitmap = convertToGray(bitmap)
            printerManager?.drawBitmap(bwBitmap, 0, startY)
            
            return startY + lineHeight
        } catch (e: Exception) {
            Log.e(TAG, "Error printing Unicode text row: ${e.message}", e)
            // Fallback to regular text printing
            printerManager?.drawText(leftText, 0, startY, "simsun", textSize.toInt(), isBold, false, 0)
            printerManager?.drawText(rightText, PAGE_WIDTH/2, startY, "simsun", textSize.toInt(), isBold, false, 0)
            return startY + (textSize.toInt() + 10)
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
                yPosition = printDivider(yPosition, 2)
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
        var y = startY
        try {
            val rawBitmap = BitmapFactory.decodeResource(resources, R.drawable.logoprint)
            if (rawBitmap != null) {
                val prepared = prepareBitmapForPrint(rawBitmap)
                val scaled = Bitmap.createScaledBitmap(prepared, 280, 95, false)
                val x = (PAGE_WIDTH - scaled.width) / 2
                printerManager?.drawBitmap(scaled, x.coerceAtLeast(0), y)
                y += scaled.height + 16
            } else {
                y += 20
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in logo: ${e.message}", e)
            y += 20
        }
        return y
    }



    private fun convertToGray(bitmap: Bitmap): Bitmap {
        val width = bitmap.width
        val height = bitmap.height
        val grayBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565)

        for (x in 0 until width) {
            for (y in 0 until height) {
                val pixel = bitmap.getPixel(x, y)
                val gray = ((pixel shr 16 and 0xff) * 0.3 +
                        (pixel shr 8 and 0xff) * 0.59 +
                        (pixel and 0xff) * 0.11).toInt()
                val newPixel = 0xFF000000.toInt() or (gray shl 16) or (gray shl 8) or gray
                grayBitmap.setPixel(x, y, newPixel)
            }
        }
        return grayBitmap
    }

    private fun convertToThreshold(bitmap: Bitmap, threshold: Int = 160): Bitmap {
        val width = bitmap.width
        val height = bitmap.height
        val bwBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565)

        for (x in 0 until width) {
            for (y in 0 until height) {
                val pixel = bitmap.getPixel(x, y)
                val gray = ((pixel shr 16 and 0xff) * 0.3 +
                        (pixel shr 8 and 0xff) * 0.59 +
                        (pixel and 0xff) * 0.11).toInt()
                val newPixel = if (gray < threshold) 0xFF000000.toInt() else 0xFFFFFFFF.toInt()
                bwBitmap.setPixel(x, y, newPixel)
            }
        }
        return bwBitmap
    }

    private fun prepareBitmapForPrint(src: Bitmap): Bitmap {
        val newBitmap = Bitmap.createBitmap(src.width, src.height, Bitmap.Config.RGB_565)
        val canvas = Canvas(newBitmap)
        canvas.drawColor(0xFFFFFFFF.toInt()) // nền trắng
        canvas.drawBitmap(src, 0f, 0f, null)
        return newBitmap
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
            val pk = flightInfo?.get("Pk") as? String ?: ""
            val deliveryBy = flightInfo?.get("DeliveryBy") as? String ?: ""
            val deliveryCode = flightInfo?.get("DeliveryCode") as? String ?: ""
            val deliveryDate = flightInfo?.get("DeliveryDate") as? String ?: ""
            val supplyFormCode = data["SupplyFormCode"] as? String ?: ""

            // Log extracted values
            Log.d(TAG, "Extracted flight data - FlightNo: $flightNo, Routing: $routing, AcfNo: $acfNo, TypeApl: $typeApl")

            // Header text - "Vietnam Airlines Caterers"
            val headerText = "Vietnam Airlines Caterers"
            yPosition = printUnicodeTextLine(headerText, yPosition, 20f, true, true)

            // Address text
            val addressLine1 = "Tan Son Nhat International Airport, Tan Son Hoa Ward,"
            val addressLine2 = "Ho Chi Minh City, Vietnam."
            yPosition = printUnicodeTextLine(addressLine1, yPosition, 16f, false, true)
            yPosition = printUnicodeTextLine(addressLine2, yPosition, 16f, false, true)

            // Phone number
            val phone = "(84 - 28) 38.448.367"
            yPosition = printUnicodeTextLine(phone, yPosition, 16f, false, true)
            yPosition += 8

            // Divider
            yPosition = printDivider(yPosition, 2)

            // Title
            val title = "Delivery and Receipt Note"
            yPosition = printUnicodeTextLine(title, yPosition, 24f, true, true)

            // Code
            val codeText = "Code: $supplyFormCode"
            yPosition = printUnicodeTextLine(codeText, yPosition, 20f, true, true)
            yPosition += 8

            // Divider
            yPosition = printDivider(yPosition)

            // Flight details - Row 1: Flight and Flight No (side by side)
            yPosition = printUnicodeTextRow("Flight: $routing", "PK: $pk", yPosition, 18f)

            // Flight details - Row 2: PK and A/C (side by side)
            yPosition = printUnicodeTextRow("Flight No: $flightNo", "A/C: $acfNo", yPosition, 18f)

            // Additional flight info - Departure
            if (departureDate.isNotEmpty()) {
                yPosition = printUnicodeTextRow("Departure: ${formatDate(departureDate)}", "", yPosition, 18f)
            }
            
            // Additional flight info - Arrival
            if (arrivalDate.isNotEmpty()) {
                yPosition = printUnicodeTextRow("Arrival: ${formatDate(arrivalDate)}", "", yPosition, 18f)
            }
            if (arrivalDate.isNotEmpty()) {
                yPosition = printUnicodeTextRow("Delivery By: ${deliveryCode} - ${deliveryBy}", "", yPosition, 18f)
            }
            if (arrivalDate.isNotEmpty()) {
                yPosition = printUnicodeTextRow("Delivery Date: ${formatDate(deliveryDate)}", "", yPosition, 18f)
            }
            yPosition += 8

            // Table header
            yPosition = printUnicodeTextRow("Name", "Qty", yPosition, 18f, true)
            yPosition += 8


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

    private fun printDivider(startY: Int ,  heightl: Int = 1): Int {
        val lineHeight = heightl  // độ dày đường kẻ
        return try {
            // tạo bitmap ngang bằng chiều rộng giấy
            val bitmap = Bitmap.createBitmap(PAGE_WIDTH, lineHeight, Bitmap.Config.RGB_565)
            val canvas = Canvas(bitmap)
            canvas.drawColor(0xFFFFFFFF.toInt()) // nền trắng

            val paint = Paint()
            paint.color = 0xFF000000.toInt()
            paint.strokeWidth = lineHeight.toFloat()

            // vẽ một line đen chạy ngang giấy
            canvas.drawLine(
                0f,
                lineHeight / 2f,
                PAGE_WIDTH.toFloat(),
                lineHeight / 2f,
                paint
            )

            printerManager?.drawBitmap(bitmap, 0, startY)

            startY + lineHeight + 8 // trả về vị trí tiếp theo (cộng thêm spacing)
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in divider: ${e.message}", e)
            startY + 8
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

                yPosition = printUnicodeTextRow("$supplyType ($supplyCode)", "", yPosition, 20f, true)

                yPosition += 4

                // Detail items
                detailItems?.forEach { item ->
                    val itemName = item["ItemName"] as? String ?: "N/A"
                    val quantity = item["Quantity"] as? Int ?: 0
                    yPosition = printUnicodeTextRow(itemName, quantity.toString(), yPosition, 18f)
                }

                // Add spacing before dashed line
                yPosition += 6
                // Dashed line separator (simulated with dotted line)
                yPosition = printDivider(yPosition)
                yPosition += 2

            }

            // Add some spacing before Total
            yPosition += 8

            // Total
            val totalSupply = data["TotalSupply"] as? Int ?: 0
            Log.d(TAG, "Total supply: $totalSupply")
            yPosition = printUnicodeTextRow("Total:", totalSupply.toString(), yPosition, 20f, true)
            yPosition += 14

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
            val qrTitleText = "Scan the QR code to view supply details"
            yPosition = printUnicodeTextLine(qrTitleText, yPosition, 20f, true, true)
            yPosition += 4

            val qrBitmap = BitmapFactory.decodeByteArray(qrCode, 0, qrCode.size)
            val prepared = prepareBitmapForPrint(qrBitmap)
            val scaled = Bitmap.createScaledBitmap(prepared, 200, 200, false) // QR 200x200 px
            val x = (PAGE_WIDTH - scaled.width) / 2
            printerManager?.drawBitmap(scaled, x.coerceAtLeast(0), yPosition)
            yPosition += scaled.height + 20
            Log.d(TAG, "QR code printed at yPosition: $yPosition")

            val signedText = "Signed/Confirmed before printing"
            yPosition = printUnicodeTextLine(signedText, yPosition, 20f, true, true)

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