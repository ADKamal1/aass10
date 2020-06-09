import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basket/Localization/translation/bloc/translation_bloc.dart';
import 'package:basket/screens/home_page/home_page.dart';
import 'package:basket/screens/home_page/store.dart';
import './translation/global_translation.dart';


class SettingsPage extends StatefulWidget {
  static const String routeName = 'SettingsPage';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslationBloc, TranslationState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color(0XFF21d493),
                title: Text(translations.text('pageNames.settings')),
//                leading: IconButton(
//                  icon: Icon(Icons.arrow_back),
//                  onPressed: () {
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context)=>HomePage(screen: new Store())));
//                  },
//                ),
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            translations.text('pages.settings.language'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          DropdownButton(
                              value: state.locale.languageCode,
                              items: translations.supportedLocales().map((l) {
                                return DropdownMenuItem(
                                  child: Text('${l.languageCode}'),
                                  value: l.languageCode,
                                );
                              }).toList(),
                              onChanged: (l) {
                                BlocProvider.of<TranslationBloc>(context).add(
                                  SwitchLanguage(language: l),
                                );
                              }),
                        ],
                      ),
                    ),
                    Divider(),
                  ]));
        });
  }
}
