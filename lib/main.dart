import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/home_page/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'Localization/translation/bloc/translation_bloc.dart';
import 'Localization/translation/global_translation.dart';
import 'Providers/products.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///
  /// Initialization of the translations based on supported language
  /// and the  fallback language (Optional)
  ///
  List<String> supportedLanguages = ["en","ar"];
  await translations.init(supportedLanguages, fallbackLanguage: 'en');

  return runApp(BlocProvider(
    create: (context) => TranslationBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Products(),
          ),
        ],
    /// I'm using the Translation bloc here to provide the selected language whenever it changes
    /// But after that , you are free to not use Bloc pattern at all
    /// @Required
    child: BlocBuilder<TranslationBloc, TranslationState>(
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: state.locale ?? translations.locale,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                const FallbackCupertinoLocalisationsDelegate(),
              ],
              supportedLocales: translations.supportedLocales(),
              title: 'Flutter Demo Localization',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),

              home:HomePage(auth: new Auth(),)
          );
        }));
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}



//
//void test() {
//  ProductController productController = new ProductController();
//  List<Product> myproducts = productController.getAllProducts();
//  print(myproducts.length.toString());
//
//}