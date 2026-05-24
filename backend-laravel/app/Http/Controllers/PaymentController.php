<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class PaymentController extends Controller
{
    public function createPayment(Request $request)
    {
        $request->validate([
            'payment_method' => 'required',
            'amount' => 'required|integer',
        ]);

        $payment = Payment::create([
            'payment_method' => $request->payment_method,
            'amount' => $request->amount,
            'status' => 'pending',
            'qris_code' => $request->payment_method === 'qris'
                ? 'QRIS-' . rand(100000, 999999)
                : null,
            'card_holder' => $request->card_holder,
        ]);

        $transaction = Transaction::create([
            'payment_id' => $payment->id,
            'transaction_code' => 'TRX-' . strtoupper(Str::random(8)),
            'amount' => $request->amount,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Payment berhasil dibuat',
            'payment' => $payment,
            'transaction' => $transaction,
        ]);
    }

    public function confirmPayment($id)
    {
        $payment = Payment::with('transaction')->findOrFail($id);

        $payment->update([
            'status' => 'paid',
        ]);

        if ($payment->transaction) {
            $payment->transaction->update([
                'status' => 'paid',
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Pembayaran berhasil dikonfirmasi',
        ]);
    }

    public function getTransactions()
    {
        $transactions = Transaction::with('payment')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $transactions,
        ]);
    }
}