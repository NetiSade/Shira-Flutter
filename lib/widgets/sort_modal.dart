import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../providers/artworks_provider.dart';

class SortModal extends StatelessWidget {
  final Function setModalState;
  final Function onDismiss;

  const SortModal({this.setModalState, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    var artworksProvider = Provider.of<ArtworksProvider>(context);
    var adm = artworksProvider.displayModel;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              image: DecorationImage(
                image: AssetImage("assets/images/bckgrnd-txtr2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                'הצג לפי',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          SwitchListTile(
            onChanged: (val) {
              setModalState(() {
                adm.descendingOrder = val;
              });
            },
            value: adm.descendingOrder,
            title: const Text('סדר יורד'),
          ),
          CheckboxListTile(
            onChanged: (val) {
              setModalState(() {
                adm.showViewed = val;
              });
            },
            value: adm.showViewed,
            title: const Text('הצג שירים שנקראו'),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/bckgrnd-txtr2.jpg"),
              fit: BoxFit.cover,
            )),
            child: Center(
              child: Text(
                'סנן לפי',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          RadioListTile(
            groupValue: adm.sortType,
            value: SortType.ArtistName,
            title: const Text('שם המחבר'),
            onChanged: (val) {
              setModalState(() {
                adm.sortType = val;
              });
            },
          ),
          RadioListTile(
            groupValue: adm.sortType,
            title: Text('שם השיר'),
            value: SortType.ArtworkName,
            onChanged: (val) {
              setModalState(() {
                adm.sortType = val;
              });
            },
          ),
          RadioListTile(
            groupValue: adm.sortType,
            value: SortType.Date,
            title: Text('תאריך פרסום'),
            onChanged: (val) {
              setModalState(() {
                adm.sortType = val;
              });
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 154,
                  height: 44,
                  child: FlatButton(
                    child: Text(
                      'ביטול',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: onDismiss,
                  ),
                ),
                ButtonTheme(
                  minWidth: 154,
                  height: 44,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'אישור',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      artworksProvider.setDisplayModel(adm);
                      onDismiss();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
