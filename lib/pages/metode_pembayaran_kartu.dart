import 'package:flutter/material.dart';

class MetodePembayaranKartuPage
    extends StatefulWidget {
  const MetodePembayaranKartuPage({
    super.key,
  });

  @override
  State<MetodePembayaranKartuPage>
      createState() =>
          _MetodePembayaranKartuPageState();
}

class _MetodePembayaranKartuPageState
    extends State<
        MetodePembayaranKartuPage> {

  bool saveCard = false;

  final TextEditingController cardNumberController =
      TextEditingController();

  final TextEditingController cardNameController =
      TextEditingController();

  final TextEditingController expiryController =
      TextEditingController();

  final TextEditingController cvvController =
      TextEditingController();

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

      // ================= BOTTOM BUTTON =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF2563EB),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
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
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ================= CARD VISUAL =================
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                        18),
                gradient:
                    const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFFFACC15),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  Row(
                    children: [

                      const Text(
                        'Name',
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight
                                  .w500,
                        ),
                      ),

                      const Spacer(),

                      // MASTERCARD
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration:
                                const BoxDecoration(
                              color: Color(
                                0xFFEA001B,
                              ),
                              shape:
                                  BoxShape
                                      .circle,
                            ),
                          ),

                          Transform.translate(
                            offset:
                                const Offset(
                                    -8,
                                    0),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration:
                                  const BoxDecoration(
                                color: Color(
                                  0xFFFF9900,
                                ),
                                shape:
                                    BoxShape
                                        .circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= TITLE =================
            const Text(
              'Detail Kartu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 16),

            // ================= NOMOR KARTU =================
            _buildTextField(
              label: 'Nomor Kartu',
              controller:
                  cardNumberController,
              keyboardType:
                  TextInputType.number,
            ),

            const SizedBox(height: 14),

            // ================= NAMA =================
            _buildTextField(
              label: 'Nama pada Kartu',
              controller:
                  cardNameController,
            ),

            const SizedBox(height: 14),

            // ================= EXPIRED + CVV =================
            Row(
              children: [

                Expanded(
                  child: _buildTextField(
                    label:
                        'Nomor Ekspirasi',
                    controller:
                        expiryController,
                    hintText: 'MM/YY',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildTextField(
                    label: 'CVV',
                    controller:
                        cvvController,
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ================= CHECKBOX =================
            InkWell(
              onTap: () {
                setState(() {
                  saveCard = !saveCard;
                });
              },
              child: Row(
                children: [

                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: saveCard,
                      onChanged: (value) {
                        setState(() {
                          saveCard =
                              value!;
                        });
                      },
                      activeColor:
                          const Color(
                        0xFF2563EB,
                      ),
                      side: const BorderSide(
                        color:
                            Color(0xFF9CA3AF),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'Simpan informasi kartu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(
                        0xFF374151,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TEXTFIELD =================
  Widget _buildTextField({
    required String label,
    required TextEditingController
        controller,
    TextInputType keyboardType =
        TextInputType.text,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        12),
                borderSide:
                    const BorderSide(
                  color: Color(
                    0xFFD1D5DB,
                  ),
                ),
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        12),
                borderSide:
                    const BorderSide(
                  color: Color(
                    0xFFD1D5DB,
                  ),
                ),
              ),
              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        12),
                borderSide:
                    const BorderSide(
                  color: Color(
                    0xFF2563EB,
                  ),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}