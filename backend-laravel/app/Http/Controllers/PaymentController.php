<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    public function createPayment(Request $request)
    {
        $validated = $request->validate([
            'murid_id' => 'required|string',
            'payment_method' => 'required|string',
            'amount' => 'required|integer',
            'card_holder' => 'nullable|string',
        ]);

        $payment = Payment::create([
            'murid_id' => $validated['murid_id'],
            'payment_method' => $validated['payment_method'],
            'amount' => $validated['amount'],
            'status' => 'pending',
            'card_holder' => $validated['card_holder'] ?? null,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Payment berhasil dibuat',
            'payment' => $payment,
        ], 201);
    }

    public function confirmPayment(Request $request, $id)
    {
        $payment = Payment::find($id);

        if (!$payment) {
            return response()->json([
                'success' => false,
                'message' => 'Payment tidak ditemukan',
            ], 404);
        }

        if ($request->has('card_holder')) {
            $payment->card_holder = $request->input('card_holder');
        }

        $payment->status = 'success';
        $payment->save();

        return response()->json([
            'success' => true,
            'message' => 'Payment berhasil dikonfirmasi',
            'payment' => $payment,
        ], 200);
    }

    public function getTransactions(Request $request)
{
    $muridId = $request->query('murid_id');

    $query = Payment::orderBy('created_at', 'desc');
    if ($muridId) {
        $query->where('murid_id', $muridId);
    }

    return response()->json([
        'success' => true,
        'message' => 'Daftar transaksi berhasil diambil',
        'data' => $query->get(),
    ], 200);
}
}