import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'metode_pembayaran.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  List transactions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {

    try {

      final response = await http.get(
        Uri.parse(
          'https://luther-nonrepayable-unguiltily.ngrok-free.dev/api/transactions',
        ),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {
          transactions = data['data'];
          isLoading = false;
        });

      } else {

        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    if (status == 'paid') {
      return const Color(0xFF16A34A);
    }

    return const Color(0xFFD97706);
  }

  Color getStatusBg(String status) {
    if (status == 'paid') {
      return const Color(0xFFDCFCE7);
    }

    return const Color(0xFFFEF3C7);
  }

  String getStatusText(String status) {
    if (status == 'paid') {
      return 'Berhasil';
    }

    return 'Menunggu';
  }

  String getPaymentMethod(dynamic payment) {

    final method =
        payment['payment_method']
            .toString();

    if (method == 'qris') {
      return 'QRIS';
    }

    if (method == 'card') {
      return 'Kartu';
    }

    return 'Pembayaran';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF3F4F6),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF3F4F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),
        title: const Text(
          'Transaksi',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  // ================= CARD =================
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(
                            20),
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                              20),
                      border: Border.all(
                        color: const Color(
                          0xFFE5E7EB,
                        ),
                      ),
                    ),

                    child: Column(
                      children: [

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [

                                const Text(
                                  'Paket Aktif',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    color: Color(
                                      0xFF111827,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                        8),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        10,
                                    vertical:
                                        4,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                      0xFFDCFCE7,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),

                                  child:
                                      const Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [

                                      CircleAvatar(
                                        radius:
                                            4,
                                        backgroundColor:
                                            Color(
                                          0xFF22C55E,
                                        ),
                                      ),

                                      SizedBox(
                                          width:
                                              6),

                                      Text(
                                        'Aktif',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              11,
                                          fontWeight:
                                              FontWeight.w600,
                                          color:
                                              Color(
                                            0xFF16A34A,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .end,
                              children: [

                                Text(
                                  'Premium',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    color: Color(
                                      0xFF3B82F6,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height:
                                        4),

                                Text(
                                  'Berlaku hingga',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        12,
                                    color:
                                        Colors
                                            .grey,
                                  ),
                                ),

                                SizedBox(
                                    height:
                                        2),

                                Text(
                                  '15 Maret 2025',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        13,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                    color: Color(
                                      0xFF111827,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 24),

                        _buildBenefit(
                          icon: Icons
                              .menu_book_rounded,
                          bgColor:
                              const Color(
                            0xFFE0E7FF,
                          ),
                          iconColor:
                              const Color(
                            0xFF2563EB,
                          ),
                          text:
                              'Akses semua materi\npembelajaran',
                        ),

                        const SizedBox(
                            height: 18),

                        _buildBenefit(
                          icon: Icons
                              .verified_rounded,
                          bgColor:
                              const Color(
                            0xFFDCFCE7,
                          ),
                          iconColor:
                              const Color(
                            0xFF16A34A,
                          ),
                          text:
                              'Sertifikat digital',
                        ),

                        const SizedBox(
                            height: 18),

                        _buildBenefit(
                          icon: Icons
                              .support_agent_rounded,
                          bgColor:
                              const Color(
                            0xFFF3E8FF,
                          ),
                          iconColor:
                              const Color(
                            0xFF9333EA,
                          ),
                          text:
                              'Konsultasi dengan mentor',
                        ),

                        const SizedBox(
                            height: 24),

                        SizedBox(
                          width:
                              double.infinity,
                          height: 48,

                          child:
                              ElevatedButton.icon(
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (
                                        context,
                                      ) =>
                                          const MetodePembayaranPage(),
                                ),
                              );
                            },

                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFF2563EB,
                              ),
                              elevation:
                                  0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),

                            icon:
                                const Icon(
                              Icons
                                  .refresh_rounded,
                              color: Colors
                                  .white,
                              size: 18,
                            ),

                            label:
                                const Text(
                              'Perpanjang Paket',
                              style:
                                  TextStyle(
                                fontSize:
                                    15,
                                fontWeight:
                                    FontWeight
                                        .w600,
                                color: Colors
                                    .white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 28),

                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w700,
                      color: Color(
                        0xFF111827,
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 14),

                  if (transactions.isEmpty)

                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets.all(
                              20),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                18),
                      ),

                      child: const Center(
                        child: Text(
                          'Belum ada transaksi',
                        ),
                      ),
                    ),

                  ...transactions.map(
                    (item) {

                      final payment =
                          item['payment'];

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),

                        width:
                            double.infinity,

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                          border: Border.all(
                            color:
                                const Color(
                              0xFFE5E7EB,
                            ),
                          ),
                        ),

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  16),

                          child: Column(
                            children: [

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [

                                  const Text(
                                    'Paket Premium',
                                    style:
                                        TextStyle(
                                      fontSize:
                                          16,
                                      fontWeight:
                                          FontWeight.w700,
                                      color:
                                          Color(
                                        0xFF111827,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    'Rp ${item['amount']}',
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          16,
                                      fontWeight:
                                          FontWeight.w700,
                                      color:
                                          Color(
                                        0xFF111827,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height:
                                      8),

                              Row(
                                children: [

                                  Icon(
                                    Icons
                                        .credit_card_rounded,
                                    size: 16,
                                    color: Colors
                                        .grey
                                        .shade500,
                                  ),

                                  const SizedBox(
                                      width:
                                          8),

                                  Text(
                                    getPaymentMethod(
                                      payment,
                                    ),

                                    style:
                                        TextStyle(
                                      fontSize:
                                          13,
                                      color:
                                          Colors.grey.shade600,
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          10,
                                      vertical:
                                          4,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          getStatusBg(
                                        item['status'],
                                      ),

                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                    ),

                                    child: Text(
                                      getStatusText(
                                        item['status'],
                                      ),

                                      style:
                                          TextStyle(
                                        fontSize:
                                            11,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            getStatusColor(
                                          item['status'],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height:
                                      12),

                              Divider(
                                color: Colors
                                    .grey
                                    .shade200,
                              ),

                              const SizedBox(
                                  height:
                                      12),

                              Row(
                                children: [

                                  const Text(
                                    'Kode Transaksi',
                                    style:
                                        TextStyle(
                                      fontSize:
                                          13,
                                      color:
                                          Color(
                                        0xFF6B7280,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    item[
                                        'transaction_code'],
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          13,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String text,
  }) {

    return Row(
      children: [

        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),

          child: Icon(
            icon,
            color: iconColor,
            size: 18,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}