// package com.vacs.gnsa

// import android.device.PrinterManager
// import android.graphics.Bitmap
// import android.graphics.BitmapFactory
// import android.util.Log
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import java.text.SimpleDateFormat
// import java.util.Date

// class MainActivity : FlutterActivity() {
//     private var printerManager: PrinterManager? = null
//     private val CHANNEL = "urovo_printer"
//     private val PAGE_WIDTH = 384 // Thiết kế cho 48mm, 203 dpi
//     private val TAG = "MainActivity"
//     private var isPrinterDevice = false

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)

//         try {
//             printerManager = PrinterManager()
//             printerManager?.open()
//             isPrinterDevice = true
//             Log.d(TAG, "Đây là thiết bị máy in. Máy in được khởi tạo thành công.")
//         } catch (e: Exception) {
//             isPrinterDevice = false
//             Log.w(TAG, "Đây không phải thiết bị máy in: ${e.message}")
//         }

//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//             .setMethodCallHandler { call, result ->
//                 if (isPrinterDevice) {
//                     when (call.method) {
//                         "printGnsa" -> {
//                             val data = call.arguments as? Map<String, Any>
//                             val flightData = data?.get("data") as? Map<String, Any>
//                             if (flightData != null) {
//                                 printFlightDetail(flightData)
//                                 result.success("Chi tiết chuyến bay đã được in thành công")
//                             } else {
//                                 Log.e(TAG, "Dữ liệu không hợp lệ: Không có dữ liệu chuyến bay")
//                                 result.error("INVALID_DATA", "Không có dữ liệu chuyến bay", null)
//                             }
//                         }
//                         "checkPrinterStatus" -> {
//                             val status = printerManager?.status
//                             result.success("Trạng thái máy in: $status")
//                         }
//                         else -> {
//                             Log.w(TAG, "Phương thức chưa được triển khai: ${call.method}")
//                             result.notImplemented()
//                         }
//                     }
//                 } else {
//                     when (call.method) {
//                         "printGnsa" -> {
//                             Log.w(TAG, "Lệnh in bị bỏ qua: Không phải thiết bị máy in")
//                             result.success("Không có máy in trên thiết bị này")
//                         }
//                         "checkPrinterStatus" -> result.success("Không có máy in")
//                         else -> {
//                             Log.w(TAG, "Phương thức chưa được triển khai hoặc bị bỏ qua: ${call.method}")
//                             result.notImplemented()
//                         }
//                     }
//                 }
//             }
//     }

//     private fun printFlightDetail(data: Map<String, Any>) {
//         if (!isPrinterDevice) {
//             Log.w(TAG, "Không thể in: Không phải thiết bị máy in")
//             return
//         }

//         try {
//             val status = printerManager?.status
//             Log.d(TAG, "Trạng thái máy in: $status")
//             if (status == PrinterManager.PRNSTS_OK) {
//                 Log.d(TAG, "Máy in sẵn sàng. Bắt đầu công việc in.")
//                 printerManager?.setupPage(PAGE_WIDTH, -1)
//                 var yPosition = 0

//                 yPosition = printLogo(yPosition)
//                 yPosition = printFlightInfo(data, yPosition)
//                 yPosition = printDivider(yPosition)
//                 yPosition = printSupplyForms(data, yPosition)
//                 yPosition = printThankYou(yPosition)
//                 yPosition += 50

//                 printerManager?.printPage(0)
//                 printerManager?.paperFeed(24)
//                 Log.d(TAG, "Công việc in hoàn tất thành công.")
//             } else {
//                 Log.e(TAG, "Máy in không sẵn sàng. Trạng thái: $status")
//             }
//         } catch (e: Exception) {
//             Log.e(TAG, "Lỗi trong quá trình in: ${e.message}", e)
//         }
//     }

//     private fun printLogo(startY: Int): Int {
//         var yPosition = startY
//         try {
//             val bitmap = BitmapFactory.decodeResource(resources, R.drawable.logoprint)
//             if (bitmap != null) {
//                 Log.d(TAG, "Ảnh logo được tải thành công.")
//                 val bwBitmap = convertToBlackAndWhite(bitmap)
//                 val scaledBitmap = Bitmap.createScaledBitmap(bwBitmap, 180,74, true) // Phù hợp 384 pixel
//                 val logoX = (PAGE_WIDTH - scaledBitmap.width) / 3
//                 printerManager?.drawBitmap(scaledBitmap, logoX.coerceAtLeast(0), yPosition)
//                 yPosition += scaledBitmap.height + 10
//                 Log.d(TAG, "Logo được in tại yPosition: $yPosition")
//             } else {
//                 Log.w(TAG, "Ảnh logo bị null. Bỏ qua việc in logo.")
//             }
//         } catch (e: Exception) {
//             Log.e(TAG, "Lỗi khi in logo: ${e.message}", e)
//         }
//         return yPosition
//     }

//     private fun convertToBlackAndWhite(bitmap: Bitmap): Bitmap {
//         val width = bitmap.width
//         val height = bitmap.height
//         val bwBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565)
//         for (x in 0 until width) {
//             for (y in 0 until height) {
//                 val pixel = bitmap.getPixel(x, y)
//                 val alpha = pixel shr 24 and 0xff
//                 val newPixel = if (alpha < 128) 0xFFFFFFFF.toInt() else 0xFF000000.toInt()
//                 bwBitmap.setPixel(x, y, newPixel)
//             }
//         }
//         Log.d(TAG, "Ảnh được chuyển thành đen trắng.")
//         return bwBitmap
//     }

//     private fun printFlightInfo(data: Map<String, Any>, startY: Int): Int {
//         var yPosition = startY
//         val lineHeight = 24

//         try {
//             val flight = data["flight"] as? Map<String, Any>
//             val flightNo = flight?.get("FlightNo") as? String ?: "N/A"
//             val routing = flight?.get("Routing") as? String ?: "N/A"
//             val flightType = flight?.get("FlightType") as? String ?: "N/A"
//             val flightDate = flight?.get("FlightDate") as? String ?: "N/A"
//             val departTime = flight?.get("ActualTimeDepart") as? String ?: "N/A"
//             val arrivalTime = flight?.get("ActualTimeArrival") as? String ?: "N/A"

//             // Header
//             val header = "✈ FLIGHT $flightNo ✈"
//             val headerX = (PAGE_WIDTH - header.length * 8) / 3
//             printerManager?.drawText(header, headerX, yPosition, "simsun", 21, true, false, 0)
//             yPosition += lineHeight

//             // Divider
//             printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight

//             // Flight details
//             printerManager?.drawText("Route: $routing       Date: ${flightDate.substring(0, 10)}".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight
//             printerManager?.drawText("Type: $flightType       Depart: ${departTime.substring(11, 16)}".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight
//             printerManager?.drawText("                       Arrive: ${arrivalTime.substring(11, 16)}".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight

//             // Closing divider
//             printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight * 2

//             Log.d(TAG, "Thông tin chuyến bay được in tại yPosition: $yPosition")
//         } catch (e: Exception) {
//             Log.e(TAG, "Lỗi khi in thông tin chuyến bay: ${e.message}", e)
//         }
//         return yPosition
//     }

//     private fun printDivider(startY: Int): Int {
//         val yPosition = startY
//         try {
//             val divider = "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~".take(48)
//             printerManager?.drawText(divider, 0, yPosition, "simsun", 18, false, false, 0)
//             Log.d(TAG, "Dòng phân cách được in tại yPosition: ${yPosition + 24}")
//             return yPosition + 24
//         } catch (e: Exception) {
//             Log.e(TAG, "Lỗi khi in dòng phân cách: ${e.message}", e)
//             return yPosition
//         }
//     }

//     private fun printSupplyForms(data: Map<String, Any>, startY: Int): Int {
//         var yPosition = startY
//         val lineHeight = 24
//         var formIndex = 1

//         try {
//             // Header
//             val header = "⌓ SUPPLY FORMS ⌓"
//             val headerX = (PAGE_WIDTH - header.length * 8) / 3
//             printerManager?.drawText(header, headerX, yPosition, "simsun", 21, true, false, 0)
//             yPosition += lineHeight
//             // Divider
//             printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight

//             val supplyForms = data["supplyForms"] as? List<Map<String, Any>>
//             supplyForms?.forEach { form ->
//                 val category = form["Category"] as? String ?: "N/A"
//                 val className = form["Class"] as? String ?: "N/A"
//                 val status = form["Status"] as? String ?: "N/A"
//                 val supplies = form["Supplies"] as? List<Map<String, Any>>

//                 printerManager?.drawText("$formIndex• $category ($className)    Status: $status".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//                 yPosition += lineHeight

//                 supplies?.forEach { supply ->
//                     val supplyName = supply["CategoryName"] as? String ?: "N/A"
//                     val items = supply["Items"] as? List<Map<String, Any>>
//                     items?.forEach { item ->
//                         val suppliedQty = item["SuppliedQuantity"] as? Int ?: 0
//                         val confirmedQty = item["ConfirmedQuantity"] as? Int ?: 0
//                         val note = item["Note"] as? String ?: "N/A"
//                         val supplyText = "   SupplyName: $supplyName".take(48)
//                         printerManager?.drawText(supplyText, 0, yPosition, "simsun", 18, false, false, 0)
//                         yPosition += lineHeight
//                         val itemText = "   Received: $suppliedQty    Note: $note".take(48)
//                         printerManager?.drawText(itemText, 0, yPosition, "simsun", 18, false, false, 0)
//                         yPosition += lineHeight

//                         val textPadding = "                                               "
//                         printerManager?.drawText(textPadding, 0, yPosition, "simsun", 18, false, false, 0)
//                         yPosition += lineHeight
//                     }
//                 }
//                 formIndex++
//                 yPosition += 8
//             }

//             // Closing divider
//             printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
//             yPosition += lineHeight * 2

//             Log.d(TAG, "Biểu mẫu cung cấp được in tại yPosition: $yPosition")
//         } catch (e: Exception) {
//             Log.e(TAG, "Lỗi khi in biểu mẫu cung cấp: ${e.message}", e)
//         }
//         return yPosition
//     }

//     private fun printThankYou(startY: Int): Int {
//         var yPosition = startY
//         try {
//             val currentTime = SimpleDateFormat("dd/MM/yyyy HH:mm").format(Date())
//             val printedText = "Printed: $currentTime"
//             val printedX = (PAGE_WIDTH - printedText.length * 8) / 2
//             printerManager?.drawText(printedText, printedX, yPosition, "simsun", 16, false, false, 0)
//             yPosition += 20

//             val thankYouText = "★ Thank You for Flying! ★"
//             val thankYouX = (PAGE_WIDTH - thankYouText.length * 8) / 2
//             printerManager?.drawText(thankYouText, thankYouX, yPosition, "simsun", 18, true, false, 0)
//             yPosition += 20

//             Log.d(TAG, "Thông điệp cảm ơn được in tại yPosition: $yPosition")
//             return yPosition
//         } catch (e: Exception) {
//             Log.e(TAG, "Lỗi khi in thông điệp cảm ơn: ${e.message}", e)
//             return yPosition
//         }
//     }

//     override fun onDestroy() {
//         super.onDestroy()
//         if (isPrinterDevice) {
//             try {
//                 printerManager?.close()
//                 Log.d(TAG, "Máy in đã được đóng thành công.")
//             } catch (e: Exception) {
//                 Log.e(TAG, "Lỗi khi đóng máy in: ${e.message}", e)
//             }
//         }
//     }
// } 



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
                yPosition = printThankYou(yPosition)
                yPosition += 400

                printerManager?.printPage(0)
                printerManager?.paperFeed(24)
                Log.d(TAG, "Công việc in hoàn tất thành công.")
            } else {
                Log.e(TAG, "Máy in không sẵn sàng. Trạng thái: $status")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi trong quá trình in: ${e.message}", e)
        }
    }

    private fun printLogo(startY: Int): Int {
        var yPosition = startY
        try {
            val bitmap = BitmapFactory.decodeResource(resources, R.drawable.logoprint)
            if (bitmap != null) {
                Log.d(TAG, "Ảnh logo được tải thành công.")
                val bwBitmap = convertToBlackAndWhite(bitmap)
                val scaledBitmap = Bitmap.createScaledBitmap(bwBitmap, 180, 74, true)
                val logoX = (PAGE_WIDTH - scaledBitmap.width) / 3
                printerManager?.drawBitmap(scaledBitmap, logoX.coerceAtLeast(0), yPosition)
                yPosition += scaledBitmap.height + 10
                Log.d(TAG, "Logo được in tại yPosition: $yPosition")
            } else {
                Log.w(TAG, "Ảnh logo bị null. Bỏ qua việc in logo.")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in logo: ${e.message}", e)
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
                val alpha = pixel shr 24 and 0xff
                val newPixel = if (alpha < 128) 0xFFFFFFFF.toInt() else 0xFF000000.toInt()
                bwBitmap.setPixel(x, y, newPixel)
            }
        }
        Log.d(TAG, "Ảnh được chuyển thành đen trắng.")
        return bwBitmap
    }

    private fun printFlightInfo(data: Map<String, Any>, startY: Int): Int {
        var yPosition = startY
        val lineHeight = 24

        try {
            val flight = data["flight"] as? Map<String, Any>
            val flightNo = flight?.get("FlightNo") as? String ?: "N/A"
            val routing = flight?.get("Routing") as? String ?: "N/A"
            val flightType = flight?.get("FlightType") as? String ?: "N/A"
            val flightDate = flight?.get("FlightDate") as? String ?: "N/A"
            val departTime = flight?.get("ActualTimeDepart") as? String ?: "N/A"
            val arrivalTime = flight?.get("ActualTimeArrival") as? String ?: "N/A"

            val header = "✈ FLIGHT $flightNo ✈"
            val headerX = (PAGE_WIDTH - header.length * 8) / 3
            printerManager?.drawText(header, headerX, yPosition, "simsun", 21, true, false, 0)
            yPosition += lineHeight

            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight

            printerManager?.drawText("Route: $routing       Date: ${flightDate.substring(0, 10)}".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight
            printerManager?.drawText("Type: $flightType       Depart: ${departTime.substring(11, 16)}".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight
            printerManager?.drawText("                       Arrive: ${arrivalTime.substring(11, 16)}".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight

            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight * 2

            Log.d(TAG, "Thông tin chuyến bay được in tại yPosition: $yPosition")
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in thông tin chuyến bay: ${e.message}", e)
        }
        return yPosition
    }

    private fun printDivider(startY: Int): Int {
        val yPosition = startY
        try {
            val divider = "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~".take(48)
            printerManager?.drawText(divider, 0, yPosition, "simsun", 18, false, false, 0)
            Log.d(TAG, "Dòng phân cách được in tại yPosition: ${yPosition + 24}")
            return yPosition + 24
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in dòng phân cách: ${e.message}", e)
            return yPosition
        }
    }
    private fun printSupplyForms(data: Map<String, Any>, startY: Int): Int {
        var yPosition = startY
        val lineHeight = 24
        var formIndex = 1
    
        try {
            val header = "⌓ SUPPLY FORMS ⌓"
            val headerX = (PAGE_WIDTH - header.length * 8) / 3
            printerManager?.drawText(header, headerX, yPosition, "simsun", 21, true, false, 0)
            yPosition += lineHeight
            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight
    
            val supplyForms = data["supplyForms"] as? List<Map<String, Any>>
            supplyForms?.forEach { form ->
                val category = form["Category"] as? String ?: "N/A"
                val className = form["Class"] as? String ?: "N/A"
                val status = form["Status"] as? String ?: "N/A"
                val supplies = form["Supplies"] as? List<Map<String, Any>>
    
                printerManager?.drawText("$formIndex• $category ($className)    Status: $status".take(48), 0, yPosition, "simsun", 18, false, false, 0)
                yPosition += lineHeight
    
                supplies?.forEach { supply ->
                    val categoryName = supply["CategoryName"] as? String ?: "N/A"
                    printerManager?.drawText("   Catagoryname: $categoryName".take(48), 0, yPosition, "simsun", 18, false, false, 0)
                    yPosition += lineHeight
    
                    val items = supply["Items"] as? List<Map<String, Any>>
                    items?.forEach { item ->
                        val supplyName = item["SupplyName"] as? String ?: "N/A"
                        val confirmedQuantity = item["ConfirmedQuantity"] as? Int ?: 0
                        val note = item["Note"] as? String ?: "N/A"
    
                        printerManager?.drawText("     SupplyName: $supplyName".take(48), 0, yPosition, "simsun", 18, false, false, 0)
                        yPosition += lineHeight
                        printerManager?.drawText("     Received: $confirmedQuantity    Note: $note".take(48), 0, yPosition, "simsun", 18, false, false, 0)
                        yPosition += lineHeight

                        yPosition += 10

                    }
                }
                formIndex++
                yPosition += 8
            }
    
            printerManager?.drawText("--------------------------------------------".take(48), 0, yPosition, "simsun", 18, false, false, 0)
            yPosition += lineHeight * 2
    
            Log.d(TAG, "Biểu mẫu cung cấp được in tại yPosition: $yPosition")
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in biểu mẫu cung cấp: ${e.message}", e)
        }
        return yPosition
    }

    private fun printThankYou(startY: Int): Int {
        var yPosition = startY
        try {
            val currentTime = SimpleDateFormat("dd/MM/yyyy HH:mm").format(Date())
            val printedText = "Printed: $currentTime"
            val printedX = (PAGE_WIDTH - printedText.length * 8) / 2
            printerManager?.drawText(printedText, printedX, yPosition, "simsun", 16, false, false, 0)
            yPosition += 20

            val thankYouText = "★ Thank You for Flying! ★"
            val thankYouX = (PAGE_WIDTH - thankYouText.length * 8) / 2
            printerManager?.drawText(thankYouText, thankYouX, yPosition, "simsun", 18, true, false, 0)
            yPosition += 20

            Log.d(TAG, "Thông điệp cảm ơn được in tại yPosition: $yPosition")
            return yPosition
        } catch (e: Exception) {
            Log.e(TAG, "Lỗi khi in thông điệp cảm ơn: ${e.message}", e)
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
