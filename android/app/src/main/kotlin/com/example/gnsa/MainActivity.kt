package com.example.gnsa

import android.device.PrinterManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.graphics.Bitmap
import android.graphics.BitmapFactory

class MainActivity : FlutterActivity() {
    private var printerManager: PrinterManager? = null
    private val CHANNEL = "urovo_printer"
    private val PAGE_WIDTH = 384

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        printerManager = PrinterManager()
        printerManager?.open()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "printGnsa" -> {
                        val data = call.arguments as? Map<String, Any>
                        val flightData = data?.get("data") as? Map<String, Any>
                        if (flightData != null) {
                            printFlightDetail(flightData)
                            result.success("Flight detail printed successfully")
                        } else {
                            result.error("INVALID_DATA", "No flight data provided", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun printFlightDetail(data: Map<String, Any>) {
        val status = printerManager?.status
        if (status == PrinterManager.PRNSTS_OK) {
            printerManager?.setupPage(PAGE_WIDTH, -1)
            var yPosition = 0

            yPosition = printLogo(yPosition)
            yPosition = printFlightInfo(data, yPosition)
            yPosition = printDivider(yPosition)
            yPosition = printSupplyForms(data, yPosition)
            yPosition = printDivider(yPosition)
            yPosition = printThankYou(yPosition) // Thêm lời cảm ơn

            // Hoàn tất in
            printerManager?.printPage(0)
            printerManager?.paperFeed(24)
        } else {
            Log.e("MainActivity", "Printer error status: $status")
        }
    }

    private fun printLogo(startY: Int): Int {
        var yPosition = startY
        try {
            val bitmap = BitmapFactory.decodeResource(resources, R.drawable.logoprint)
            if (bitmap != null) {
                val bwBitmap = convertToBlackAndWhite(bitmap)
                val scaledBitmap = Bitmap.createScaledBitmap(bwBitmap, 200, 80, true)
                val logoX = (PAGE_WIDTH - scaledBitmap.width) / 2 // Căn giữa logo
                printerManager?.drawBitmap(scaledBitmap, logoX.coerceAtLeast(0), yPosition)
                yPosition += scaledBitmap.height + 8
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error printing logo: ${e.message}")
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
        return bwBitmap
    }

    private fun printFlightInfo(data: Map<String, Any>, startY: Int): Int {
        var yPosition = startY
        val lineHeight = 28
        val labelWidth = 100

        val flight = data["flight"] as? Map<String, Any>
        val flightNo = flight?.get("FlightNo") as? String ?: "N/A"
        val routing = flight?.get("Routing") as? String ?: "N/A"
        val flightType = flight?.get("FlightType") as? String ?: "N/A"
        val flightDate = flight?.get("FlightDate") as? String ?: "N/A"
        val departTime = flight?.get("ActualTimeDepart") as? String ?: "N/A"
        val arrivalTime = flight?.get("ActualTimeArrival") as? String ?: "N/A"

        val header = "~ FLIGHT $flightNo ~"
        val headerX = (PAGE_WIDTH - header.length * 12) / 2
        printerManager?.drawText(header, headerX, yPosition, "simsun", 28, true, false, 0)
        yPosition += lineHeight * 2

        printerManager?.drawText("Route    :", 0, yPosition, "simsun", 24, false, false, 0)
        printerManager?.drawText(routing, labelWidth, yPosition, "simsun", 24, false, false, 0)
        yPosition += lineHeight

        printerManager?.drawText("Type     :", 0, yPosition, "simsun", 24, false, false, 0)
        printerManager?.drawText(flightType, labelWidth, yPosition, "simsun", 24, false, false, 0)
        yPosition += lineHeight

        printerManager?.drawText("Date     :", 0, yPosition, "simsun", 24, false, false, 0)
        printerManager?.drawText(flightDate.substring(0, 10), labelWidth, yPosition, "simsun", 24, false, false, 0)
        yPosition += lineHeight

        printerManager?.drawText("Depart   :", 0, yPosition, "simsun", 24, false, false, 0)
        printerManager?.drawText(departTime.substring(11, 16), labelWidth, yPosition, "simsun", 24, false, false, 0)
        yPosition += lineHeight

        printerManager?.drawText("Arrival  :", 0, yPosition, "simsun", 24, false, false, 0)
        printerManager?.drawText(arrivalTime.substring(11, 16), labelWidth, yPosition, "simsun", 24, false, false, 0)
        yPosition += lineHeight * 2

        return yPosition
    }

    private fun printSupplyForms(data: Map<String, Any>, startY: Int): Int {
        var yPosition = startY
        val lineHeight = 28
        val smallLineHeight = 24
        var formIndex = 1

        val supplyHeader = "** SUPPLY FORMS **"
        val supplyHeaderX = (PAGE_WIDTH - supplyHeader.length * 12) / 2
        printerManager?.drawText(supplyHeader, supplyHeaderX, yPosition, "simsun", 24, true, false, 0)
        yPosition += lineHeight * 2

        val supplyForms = data["supplyForms"] as? List<Map<String, Any>>
        supplyForms?.forEach { form ->
            val code = form["SupplyFormCode"] as? String ?: "N/A"
            val category = form["Category"] as? String ?: "N/A"
            val className = form["Class"] as? String ?: "N/A"
            val total = form["TotalSupply"] as? Int ?: 0
            val status = form["Status"] as? String ?: "N/A"
            val supplies = form["Supplies"] as? List<Map<String, Any>>

            val formTitle = "$formIndex. $category ($className)".take(35)
            printerManager?.drawText(formTitle, 0, yPosition, "simsun", 20, true, false, 0)
            yPosition += smallLineHeight

            val detailsText = "Code: $code | Total: $total | Status: $status".take(50)
            printerManager?.drawText(detailsText, 10, yPosition, "simsun", 18, false, false, 0)
            yPosition += smallLineHeight

            supplies?.forEach { supply ->
                val supplyName = supply["Supplys"] as? String ?: "N/A"
                val items = supply["Items"] as? List<Map<String, Any>>

                printerManager?.drawText("- $supplyName", 10, yPosition, "simsun", 18, false, false, 0)
                yPosition += smallLineHeight

                items?.forEach { item ->
                    val suppliedQty = item["SuppliedQuantity"] as? Int ?: 0
                    val confirmedQty = item["ConfirmedQuantity"] as? Int ?: 0
                    val note = item["Note"] as? String ?: "N/A"

                    val itemText = "Supplied: $suppliedQty | Confirmed: $confirmedQty | Note: $note".take(50)
                    printerManager?.drawText(itemText, 20, yPosition, "simsun", 16, false, false, 0)
                    yPosition += smallLineHeight
                }
            }
            yPosition += lineHeight
            formIndex++
        }

        return yPosition
    }

    private fun printDivider(startY: Int): Int {
        val yPosition = startY
        val divider = "=".repeat(PAGE_WIDTH / 10)
        printerManager?.drawText(divider, 0, yPosition, "simsun", 24, false, false, 0)
        return yPosition + 32
    }

    private fun printThankYou(startY: Int): Int {
        val yPosition = startY
        val currentTime = java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(java.util.Date())
        val footerText = "Printed on $currentTime - Thank you!"
        val footerX = (PAGE_WIDTH - footerText.length * 12) / 2
        printerManager?.drawText(footerText, footerX, yPosition, "simsun", 20, false, false, 0)
        return yPosition + 32
    }

    override fun onDestroy() {
        super.onDestroy()
        printerManager?.close()
    }
}