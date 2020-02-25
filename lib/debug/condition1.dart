import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widget/common_divider.dart';

class DebugCondition extends StatefulWidget {
  // どっかから持ってきたやつで、不要なのもそのまま
  final Product product = Product(
      brand: 'Levis',
      description: 'Print T-shirt',
      image:
          'https://mosaic02.ztat.net/vgs/media/pdp-zoom/LE/22/1D/02/2A/12/LE221D022-A12@16.1.jpg',
      name: 'THE PERFECT',
      price: '£19.99',
      rating: 4.0,
      colors: [
        ProductColor(
          color: Colors.blue,
          colorName: '一般名及び販売名',
        ),
        ProductColor(
          color: Colors.blue,
          colorName: '一般名のみ',
        ),
        ProductColor(
          color: Colors.blue,
          colorName: '販売名のみ',
        ),
      ],
      quantity: 0,
      sizes: ['部分一致', '前方一致'],
      totalReviews: 170);

  @override
  _ShoppingActionState createState() {
    return _ShoppingActionState();
  }
}

class _ShoppingActionState extends State<DebugCondition> {
  String _value = '一般名のみ';
  String _sizeValue = '部分一致';

  Widget colorsCard() => Column(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.start,
            children: widget.product.colors
                .map(
                  (pc) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      selectedColor: Colors.blue, //pc.color,
                      label: Text(
                        pc.colorName,
                        style: TextStyle(fontSize: 12, color: Colors.black),
//                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      selected: _value == pc.colorName,
                      onSelected: (selected) {
                        setState(
                          () {
                            _value = selected ? pc.colorName : null;
                          },
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );

  Widget sizesCard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: widget.product.sizes
                .map((pc) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                          selectedColor: Colors.blue,
                          label: Text(
                            pc,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          selected: _sizeValue == pc,
                          onSelected: (selected) {
                            setState(() {
                              _sizeValue = selected ? pc : null;
                            });
                          }),
                    ))
                .toList(),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommonDivider(),
        Container(
          margin: EdgeInsets.only(left: 8, top: 8),
          child: Text('検索条件', style: TextStyle(fontSize: 16)),
        ),
        colorsCard(),
        CommonDivider(),
        const SizedBox(
          height: 5.0,
        ),
        sizesCard(),
//        CommonDivider(),
//        const SizedBox(
//          height: 5.0,
//        ),
//        quantityCard(),
//        SizedBox(
//          height: 20.0,
//        ),
      ],
    );
  }
}
