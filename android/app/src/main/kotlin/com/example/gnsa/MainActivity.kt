package com.example.gnsa

import android.device.PrinterManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    // private var printerManager: PrinterManager? = null

    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     printerManager = PrinterManager()
    //     printerManager?.open()

    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    //         .setMethodCallHandler { call, result ->
    //             if (call.method == "printText") {
    //                 val text = call.argument<String>("text") ?: "hello"
    //                 printText(text)
    //                 result.success("Printed successfully")
    //             } else {
    //                 result.notImplemented()
    //             }
    //         }
    // }

    // private fun printText(text: String) {
    //     val status = printerManager?.status
    //     if (status == PrinterManager.PRNSTS_OK) {
    //         printerManager?.setupPage(384, -1)

    //         // Giả sử text là một chuỗi có nhiều dòng, tách chúng ra
    //         val lines = text.split("\n")
    //         var yPosition = 0
    //         val lineHeight = 24 // Chiều cao dòng, có thể điều chỉnh để giảm khoảng cách

    //         for (line in lines) {
    //             printerManager?.drawText(line, 0, yPosition, "simsun", 24, false, false, 0)
    //             yPosition += lineHeight // Di chuyển yPosition xuống cho dòng tiếp theo
    //         }

    //         printerManager?.printPage(0)
    //         printerManager?.paperFeed(16)
    //     } else {
    //         Log.e("MainActivity", "Printer error status: $status")
    //         // Xử lý trạng thái lỗi của máy in
    //     }
    // }

    // override fun onDestroy() {
    //     super.onDestroy()
    //     printerManager?.close()
    // }

    // companion object {
    //     private const val CHANNEL = "urovo_printer"
    // }
}