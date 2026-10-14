import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/utils/format.dart';
import '../domain/auto_read.dart';

/// The demo's sample documents (spec 12): drawn as A4 pages and clearly
/// stamped SAMPLE. They are printed papers, so like real Indian clinic
/// paperwork they are in English; the app around them is translated.
/// What auto-read "finds" ([sampleDetails]) is exactly what is printed here.
class SampleDocument extends StatelessWidget {
  const SampleDocument({super.key, required this.sampleKey, required this.petName, required this.issuedOn});
  final String sampleKey;
  final String petName;
  final DateTime issuedOn;

  static const size = Size(595, 842);
  static const _ink = Color(0xFF1C2B2D);
  static const _muted = Color(0xFF5B6B6E);
  static const _line = Color(0xFFE5E1DA);

  @override
  Widget build(BuildContext context) {
    final d = sampleDetails(sampleKey, petName: petName, issuedOn: issuedOn);
    final (title, header, sub, accent) = switch (sampleKey) {
      'insurance_policy' => ('PET INSURANCE · POLICY SCHEDULE', d.insurer ?? '', 'Customer care 1800 000 0000 (sample)', const Color(0xFF6D5BD0)),
      'lab_report' => ('LABORATORY REPORT', d.clinicName ?? '', 'NABL-style demo lab · Indiranagar, Bengaluru', const Color(0xFF0369A1)),
      'invoice' => ('TAX INVOICE', d.clinicName ?? '', '100 Feet Road, Indiranagar, Bengaluru 560038', const Color(0xFFB45309)),
      'licence' => ('PET DOG LICENCE', d.issuer ?? '', 'Veterinary Services Department', const Color(0xFF7C5E2A)),
      'adoption' => ('ADOPTION CERTIFICATE', d.issuer ?? '', 'Registered animal welfare shelter (sample)', const Color(0xFFBE185D)),
      'travel' => ('HEALTH CERTIFICATE FOR TRAVEL', d.issuer ?? '', 'Issued for domestic travel by road, rail or air', const Color(0xFF047857)),
      'prescription' => ('PRESCRIPTION', d.clinicName ?? '', '100 Feet Road, Indiranagar, Bengaluru 560038', const Color(0xFF15803D)),
      _ => ('CERTIFICATE OF VACCINATION', d.clinicName ?? '', '100 Feet Road, Indiranagar, Bengaluru 560038', const Color(0xFF0F766E)),
    };
    String date(DateTime? x) => x == null ? '–' : Fmt.date(x);
    final rows = <(String, String)>[
      ('Pet name', petName),
      ...switch (sampleKey) {
        'insurance_policy' => [
            ('Policy number', d.policyNo ?? ''),
            ('Period of cover', '${date(d.coverStart)} to ${date(d.expiry)}'),
            ('Sum insured', Fmt.inr(d.cover ?? 0)),
            ('Annual premium', '${Fmt.inr(d.premium ?? 0)} (incl. taxes)'),
            ('Covers', 'Illness, accidents, surgery, hospital stay'),
            ('Waiting period', '30 days for illness'),
          ],
        'lab_report' => [
            ('Test', d.testName ?? ''),
            ('Sample collected', date(d.issuedOn)),
            ('Referred by', d.vetName ?? ''),
          ],
        'invoice' => [
            ('Invoice number', d.referenceNo ?? ''),
            ('Date', date(d.issuedOn)),
          ],
        'licence' => [
            ('Licence number', d.referenceNo ?? ''),
            ('Issued on', date(d.issuedOn)),
            ('Valid till', date(d.expiry)),
          ],
        'adoption' => [
            ('Certificate number', d.referenceNo ?? ''),
            ('Date of adoption', date(d.issuedOn)),
            ('Adopted by', 'Pet parent (sample)'),
          ],
        'travel' => [
            ('Certificate number', d.referenceNo ?? ''),
            ('Examined on', date(d.issuedOn)),
            ('Valid till', date(d.expiry)),
            ('Finding', 'Healthy and fit to travel'),
          ],
        'prescription' => [
            ('Date', date(d.issuedOn)),
            ('Doctor', '${d.vetName} · Reg. ${d.vetRegNo}'),
          ],
        _ => [
            ('Vaccine', d.vaccineName ?? ''),
            ('Brand and batch', '${d.brand} · ${d.batch}'),
            ('Date given', date(d.dateGiven)),
            ('Next due', date(d.nextDue)),
            ('Veterinarian', '${d.vetName} · Reg. ${d.vetRegNo}'),
          ],
      },
    ];
    final table = <List<String>>[
      if (sampleKey == 'lab_report') ...[
        ['Haemoglobin', '15.2 g/dL', '12 – 18'],
        ['Total WBC count', '11.8 ×10³/µL', '6 – 17'],
        ['Platelets', '310 ×10³/µL', '200 – 500'],
        ['RBC count', '7.1 ×10⁶/µL', '5.5 – 8.5'],
      ],
      if (sampleKey == 'invoice') ...[
        ['Consultation', '1', '₹600'],
        ['Vaccination', '1', '₹950'],
        ['Deworming tablet', '1', '₹300'],
        ['Total', '', '₹1,850'],
      ],
      if (sampleKey == 'prescription') ...[
        ['Ear drops (sample)', '3 drops twice a day', '7 days'],
        ['Probiotic sachet (sample)', '1 sachet with food', '5 days'],
      ],
    ];
    final tableHead = switch (sampleKey) {
      'lab_report' => ['Parameter', 'Result', 'Reference range'],
      'invoice' => ['Item', 'Qty', 'Amount'],
      _ => ['Medicine', 'Dose', 'For'],
    };
    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'PlusJakartaSans', color: _ink, fontSize: 12, height: 1.4),
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              color: accent,
              padding: const EdgeInsets.fromLTRB(36, 28, 36, 22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(header, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: Color(0xE6FFFFFF), fontSize: 11)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 26, 36, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(title, style: TextStyle(color: accent, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                const SizedBox(height: 18),
                for (final r in rows)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _line))),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 150, child: Text(r.$1, style: const TextStyle(color: _muted))),
                      Expanded(child: Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w600))),
                    ]),
                  ),
                if (table.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  _row(tableHead, head: true),
                  for (final r in table) _row(r),
                ],
                if (sampleKey == 'lab_report') ...[
                  const SizedBox(height: 12),
                  const Text('Comment: all values within normal limits.', style: TextStyle(color: _muted)),
                ],
              ]),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 0, 36, 18),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Text('This is a sample made for the PawSetu demo.\nIt is not a real document.',
                      style: TextStyle(color: _muted.withValues(alpha: 0.9), fontSize: 9)),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(d.vetName ?? 'Authorised signatory',
                      style: const TextStyle(fontFamily: 'PlusJakartaSans', fontStyle: FontStyle.italic, fontSize: 15, color: Color(0xFF1E3A8A))),
                  Container(width: 150, height: 1, color: _ink),
                  const SizedBox(height: 2),
                  const Text('Signature and seal', style: TextStyle(color: _muted, fontSize: 9)),
                ]),
              ]),
            ),
          ]),
          // The big SAMPLE stamp.
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Transform.rotate(
                  angle: -math.pi / 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x66DC2626), width: 6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('SAMPLE',
                        style: TextStyle(color: Color(0x66DC2626), fontSize: 96, fontWeight: FontWeight.w700, letterSpacing: 10)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  static Widget _row(List<String> cells, {bool head = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: head ? const Color(0xFFF1EDE8) : null,
          border: const Border(bottom: BorderSide(color: _line)),
        ),
        child: Row(children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              flex: i == 0 ? 3 : 2,
              child: Text(cells[i], style: TextStyle(fontWeight: head || cells[0] == 'Total' ? FontWeight.w700 : FontWeight.w400, fontSize: 11)),
            ),
        ]),
      );
}
