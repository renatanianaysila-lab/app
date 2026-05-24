import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Transaksi',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================== CARD PAKET =====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Paket Aktif',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Badge Aktif
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFF22C55E),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Aktif',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Premium',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Berlaku hingga',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '15 Maret 2025',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildBenefit(
                    icon: Icons.menu_book_rounded,
                    bgColor: const Color(0xFFE0E7FF),
                    iconColor: const Color(0xFF2563EB),
                    text: 'Akses semua materi\npembelajaran',
                  ),

                  const SizedBox(height: 18),

                  _buildBenefit(
                    icon: Icons.verified_rounded,
                    bgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    text: 'Sertifikat digital',
                  ),

                  const SizedBox(height: 18),

                  _buildBenefit(
                    icon: Icons.support_agent_rounded,
                    bgColor: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF9333EA),
                    text: 'Konsultasi dengan mentor',
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Perpanjang Paket',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Riwayat Transaksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 14),

            _buildTransactionCard(
              paket: 'Paket Premium',
              harga: 'Rp 30.000',
              tanggal: '15 Februari 2024',
              metode: 'Transfer Bank',
              status: 'Berhasil',
              statusBg: const Color(0xFFDCFCE7),
              statusColor: const Color(0xFF16A34A),
            ),

            const SizedBox(height: 14),

            _buildTransactionCard(
              paket: 'Paket Premium',
              harga: 'Rp 30.000',
              tanggal: '25 Desember 2023',
              metode: 'E-Wallet',
              status: 'Menunggu',
              statusBg: const Color(0xFFFEF3C7),
              statusColor: const Color(0xFFD97706),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== BENEFIT ITEM =====================
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

  // ===================== TRANSACTION CARD =====================
  Widget _buildTransactionCard({
    required String paket,
    required String harga,
    required String tanggal,
    required String metode,
    required String status,
    required Color statusBg,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Paket Premium',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                harga,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 6),
              Text(
                tanggal,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(
            color: Colors.grey.shade200,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                Icons.credit_card_rounded,
                size: 16,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 8),
              Text(
                metode,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}