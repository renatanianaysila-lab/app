import 'package:flutter/material.dart';
import 'metode_pembayaran_qris.dart';
import 'metode_pembayaran_kartu.dart';

class MetodePembayaranPage extends StatefulWidget {
  const MetodePembayaranPage({super.key});

  @override
  State<MetodePembayaranPage> createState() =>
      _MetodePembayaranPageState();
}

class _MetodePembayaranPageState
    extends State<MetodePembayaranPage> {

  // default belum pilih
  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF3F4F6),

      // ================= APPBAR =================
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
          'Pembayaran',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),

      // ================= BOTTOM =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
        ),
        child: Row(
          children: [

            // TOTAL
            const Expanded(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(
                        0xFF9CA3AF,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Rp 30.000',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .w700,
                      color: Color(
                        0xFF111827,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BUTTON
            SizedBox(
              width: 160,
              height: 46,
              child: ElevatedButton(
                onPressed: () {

                  // ================= QRIS =================
                  if (selectedMethod ==
                      1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const MetodePembayaranQrisPage(),
                      ),
                    );
                  }

                  // ================= KARTU =================
                  else if (selectedMethod ==
                      2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const MetodePembayaranKartuPage(),
                      ),
                    );
                  }

                  // ================= VA =================
                  else if (selectedMethod ==
                      3) {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fitur Virtual Account segera hadir',
                        ),
                      ),
                    );
                  }

                  // ================= BELUM PILIH =================
                  else {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pilih metode pembayaran terlebih dahulu',
                        ),
                      ),
                    );
                  }
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF2563EB,
                  ),
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                14),
                  ),
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
            16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ================= TOTAL CARD =================
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF2563EB),
                borderRadius:
                    BorderRadius.circular(
                        14),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [

                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  Row(
                    children: [

                      Text(
                        'Rp 30.000',
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 15,
                          fontWeight:
                              FontWeight
                                  .w500,
                        ),
                      ),

                      SizedBox(width: 6),

                      Icon(
                        Icons
                            .keyboard_arrow_down_rounded,
                        color:
                            Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= TITLE =================
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w700,
                color: Color(
                  0xFF111827,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= QRIS =================
            _buildPaymentCard(
              id: 1,
              icon:
                  Icons.qr_code_rounded,
              title: 'QRIS',
            ),

            const SizedBox(height: 12),

            // ================= KARTU =================
            _buildPaymentCard(
              id: 2,
              icon: Icons
                  .credit_card_rounded,
              title:
                  'Kartu Kredit / Debit',
            ),

            const SizedBox(height: 12),

            // ================= VA =================
            _buildPaymentCard(
              id: 3,
              icon: Icons
                  .account_balance_rounded,
              title:
                  'Virtual Account Transfer',
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildPaymentCard({
    required int id,
    required IconData icon,
    required String title,
  }) {

    bool isSelected =
        selectedMethod == id;

    return InkWell(
      borderRadius:
          BorderRadius.circular(14),

      onTap: () {
        setState(() {
          selectedMethod = id;
        });
      },

      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
                  14),

          border: Border.all(
            color: isSelected
                ? const Color(
                    0xFF2563EB)
                : const Color(
                    0xFFE5E7EB),
            width: 1.5,
          ),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              size: 22,
              color: const Color(
                0xFF111827,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w500,
                  color: Color(
                    0xFF374151,
                  ),
                ),
              ),
            ),

            // ================= RADIO =================
            AnimatedContainer(
              duration:
                  const Duration(
                      milliseconds:
                          200),

              width: 20,
              height: 20,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: isSelected
                      ? const Color(
                          0xFF2563EB)
                      : const Color(
                          0xFFD1D5DB),
                  width: 2,
                ),
              ),

              child: Center(
                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                          milliseconds:
                              200),

                  width:
                      isSelected
                          ? 10
                          : 0,

                  height:
                      isSelected
                          ? 10
                          : 0,

                  decoration:
                      const BoxDecoration(
                    color: Color(
                      0xFF2563EB,
                    ),
                    shape:
                        BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}