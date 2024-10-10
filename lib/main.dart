import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: OnboardingCarousel(),
      ),
    );
  }
}

class OnboardingCarousel extends StatelessWidget {
  final List<OnboardingItem> items = [
    OnboardingItem(
      imagePath: 'assets/images/workout1.png',
      title: 'Start Your Journey Towards A More Active Lifestyle',
    ),
    OnboardingItem(
      imagePath: 'assets/images/workout2.png',
      title: 'Find Nutrition Tips That Fit Your Lifestyle',
    ),
    OnboardingItem(
      imagePath: 'assets/images/workout3.png',
      title: 'A Community For You, Challenge Yourself',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        enlargeCenterPage: true,
      ),
      itemCount: items.length,
      itemBuilder: (context, index, realIdx) {
        final item = items[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Fundo para melhor leitura do texto
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26, // Ajuste o tamanho da fonte
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30), // Espaçamento maior
                ElevatedButton(
                  onPressed: () {
                    // Lógica para avançar para o próximo item
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Cor do botão
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                    ),
                  ),
                  child: Text(
                    index == items.length - 1 ? 'Get Started' : 'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Lógica para pular
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class OnboardingItem {
  final String imagePath;
  final String title;

  OnboardingItem({
    required this.imagePath,
    required this.title,
  });
}
