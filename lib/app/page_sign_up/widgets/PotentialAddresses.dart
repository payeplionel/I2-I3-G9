import 'package:flutter/material.dart';
import '../../page_dogs_ride/widgets/filter_trips.dart';

class PotentialsAddresses extends StatefulWidget {
  PotentialsAddresses(
      {Key? key,
      required this.potentialAddress,
      required this.actualAddress,
      required this.createAccount})
      : super(key: key);

  List<String> potentialAddress;
  int actualAddress;
  Function createAccount;

  @override
  _PotentialsAddressesState createState() => _PotentialsAddressesState();
}

class _PotentialsAddressesState extends State<PotentialsAddresses> {
  late String selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.potentialAddress.first;
    widget.actualAddress = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Text(
              'Votre adresse est ambiguë. Veuillez sélectionner ou modifier votre adresse.',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.potentialAddress.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile<String>(
                title: Text(widget.potentialAddress[index]),
                value: widget.potentialAddress[index],
                activeColor: Theme.of(context).primaryColor,
                groupValue: selectedAddress,
                onChanged: (value) {
                  setState(() {
                    selectedAddress = value!;
                    widget.actualAddress = index;
                    print(widget.potentialAddress[widget.actualAddress]);
                  });
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: OutlinedButton(
                onPressed: () {
                  widget.createAccount(
                      widget.potentialAddress[widget.actualAddress]);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Créer son compte',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            )),
          ],
        )
      ],
    );
  }
}
