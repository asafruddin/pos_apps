import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_app/presentation/pages/main_navigation.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/complete.svg'),
            Text(
              'Transaksi Sukses!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6.0),
            RichText(
                text: TextSpan(
                    text: 'Metode Pembayaran: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                  TextSpan(
                    text: 'Tunai',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  )
                ]))
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                  onPressed: () {
                    const snackBar = SnackBar(content: Text('Struk Tercetak'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Cetak Struk')),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavigation(),
                        ),
                        (route) => false);
                  },
                  child: const Text('Buat Pesanan Baru'))
            ],
          ),
        ),
      ),
    );
  }
}
