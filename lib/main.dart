import 'package:flutter/material.dart';

// Main App
void main() => runApp(new App());

// App Name
String appName = "Tip Calculator";

// Root widget of the application
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: appName,
        theme: new ThemeData(primarySwatch: Colors.indigo),
        home: new AppContainer(title: appName));
  }
}

// App Container
class AppContainer extends StatelessWidget {
  AppContainer({Key key, this.title}) : super(key: key);

  // App title
  final String title;

  // Text Editing Controllers
  final TextEditingController billAmountFieldController =
      new TextEditingController();
  final TextEditingController tipPercentageFieldController =
      new TextEditingController();
  final TextEditingController totalAmountFieldController =
      new TextEditingController();
  final TextEditingController tipAmountFieldController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Column(
            children: <Widget>[
              new InputFieldWidget(
                title: appName,
                billAmountFieldController: billAmountFieldController,
                tipPercentageFieldController: tipPercentageFieldController,
                totalAmountFieldController: totalAmountFieldController,
                tipAmountFieldController: tipAmountFieldController),
            new ResetWidget(),
    ])

//      color: Colors.indigo,
//      child: new InputFieldWidget(title: appName,
//          billAmountFieldController: billAmountFieldController,
//          tipPercentageFieldController: tipPercentageFieldController,
//          totalAmountFieldController: totalAmountFieldController,
//          tipAmountFieldController: tipAmountFieldController),
//      child: new Column(
//          children: <Widget>[
//            new InputFieldWidget(
//                title: appName,
//                billAmountFieldController: billAmountFieldController,
//                tipPercentageFieldController: tipPercentageFieldController,
//                totalAmountFieldController: totalAmountFieldController,
//              tipAmountFieldController: tipAmountFieldController),
//            new ResetWidget(),
//          ]),
        );
  }
}

// Widget that holds all the input fields
class InputFieldWidget extends StatefulWidget {
  InputFieldWidget(
      {Key key,
      this.title,
      this.billAmountFieldController,
      this.tipPercentageFieldController,
      this.totalAmountFieldController,
      this.tipAmountFieldController})
      : super(key: key);

  // App title
  final String title;

  // Text Editing Controllers
  final TextEditingController billAmountFieldController;
  final TextEditingController tipPercentageFieldController;
  final TextEditingController totalAmountFieldController;
  final TextEditingController tipAmountFieldController;

  @override
  _InputFieldWidgetState createState() => new _InputFieldWidgetState(
      billAmountFieldController,
      tipPercentageFieldController,
      totalAmountFieldController,
      tipAmountFieldController);
}

// Widget that holds the Reset button
class ResetWidget extends StatelessWidget {
  ResetWidget(
      {Key key,
      this.billAmountFieldController,
      this.tipPercentageFieldController,
      this.totalAmountFieldController,
      this.tipAmountFieldController})
      : super(key: key);

  // Text Editing Controllers
  final TextEditingController billAmountFieldController;
  final TextEditingController tipPercentageFieldController;
  final TextEditingController totalAmountFieldController;
  final TextEditingController tipAmountFieldController;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new MaterialButton(
          color: Colors.indigo,
          height: 16.0,
          child: new Text("Reset",
              textAlign: TextAlign.center,
              style: new TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            billAmountFieldController.clear();
            tipAmountFieldController.clear();
            totalAmountFieldController.clear();
          }),
    );
  }
}

// Holds the content & state of the input fields
class _InputFieldWidgetState extends State<InputFieldWidget> {
  _InputFieldWidgetState(
      this.billAmountFieldController,
      this.tipPercentageFieldController,
      this.totalAmountFieldController,
      this.tipAmountFieldController);

  // Value (State) placeholders
  double billAmount = 0.0;
  double totalAmount = 0.0;
  double tipAmount = 0.0;
  double tipPercentage = 15.0;

  // Input fields
  TextField billAmountField;
  TextField tipPercentageField;
  TextField totalAmountTextField;
  TextField tipAmountTextField;

  // Text Editing Controllers
  TextEditingController billAmountFieldController;
  TextEditingController tipPercentageFieldController;
  TextEditingController totalAmountFieldController;
  TextEditingController tipAmountFieldController;

  // Method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    tipPercentageFieldController.text = "15";

    return new Scaffold(
      // 'App Bar' for the application
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Builder(
        // Inner BuildContext for onPressed access reference to Scaffold
        builder: (BuildContext context) {
          return new GridView.count(
            primary: false,
            padding: const EdgeInsets.all(60.0),
            crossAxisSpacing: 160.0,
            crossAxisCount: 2,
            children: <Widget>[
              billAmountField = new TextField(
                  controller: billAmountFieldController,
                  decoration: new InputDecoration(labelText: "Billed Amount"),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    try {
                      if (double.parse(value) > 0.0) {
                        billAmount = double.parse(value);
                      } else {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text("Invalid Billed Amount."),
                            ));

                        // Reset billed amount back to 0
                        billAmount = 0.0;

                        // Reset calculated fields
                        tipAmountFieldController.clear();
                        totalAmountFieldController.clear();
                      }

                      if (billAmount > 0.0) {
                        if (tipPercentage >= 0.0 && tipPercentage <= 100.0) {
                          if (tipPercentage == 0.0) {
                            tipAmount = 0.0;
                          } else {
                            tipAmount = billAmount * (tipPercentage / 100.0);
                          }
                          totalAmount = tipAmount + billAmount;

                          tipAmountFieldController.text = tipAmount.toString();
                          totalAmountFieldController.text =
                              totalAmount.toString();
                        }
                      }
                    } catch (exception) {
                      billAmount = 0.0;
                      tipAmount = 0.0;
                      totalAmount = 0.0;

                      billAmountFieldController.clear();
                      tipAmountFieldController.clear();
                      totalAmountFieldController.clear();

                      if (tipPercentage >= 0.0 && tipPercentage <= 100.0) {
                        tipPercentage = 15.0;
                        tipAmountFieldController.text =
                            tipPercentage.toString();
                      }

                      Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text(
                                "Invalid Bill Amount. " + exception.toString()),
                          ));
                    }
                  }),
              tipPercentageField = new TextField(
                  controller: tipPercentageFieldController,
                  decoration: new InputDecoration(
                    labelText: "Tip (\%)",
                    hintText: "15",
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    try {
                      if (double.parse(value) >= 0.0 &&
                          double.parse(value) <= 100.0) {
                        tipPercentage = double.parse(value);
                        if (billAmount > 0.0) {
                          if (tipPercentage == 0.0) {
                            tipAmount = 0.0;
                          } else {
                            tipAmount = billAmount * (tipPercentage / 100.0);
                          }

                          tipAmountFieldController.text = tipAmount.toString();
                          totalAmountFieldController.text =
                              (tipAmount + billAmount).toString();
                        }
                      } else {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(
                                  "Invalid Tip Percentage. Resetting to default."),
                            ));

                        tipAmount = 0.0;
                        tipAmountFieldController.clear();

                        totalAmount = 0.0;
                        totalAmountFieldController.clear();

                        tipPercentage = 15.0;
                        tipPercentageFieldController.text =
                            tipPercentage.toString();
                      }
                    } catch (exception) {
                      tipAmount = 0.0;
                      tipAmountFieldController.clear();

                      totalAmount = 0.0;
                      totalAmountFieldController.clear();

                      tipPercentage = 15.0;
                      tipPercentageFieldController.text =
                          tipPercentage.toString();

                      Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Invalid Tip Percentage. " +
                                exception.toString()),
                          ));
                    }
                  }),
              totalAmountTextField = new TextField(
                  controller: totalAmountFieldController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    labelText: "Total Amount",
                  ),
                  onChanged: (String value) {
                    try {
                      if (double.parse(value) >= 0.0) {
                        totalAmount = double.parse(value);

                        if (billAmount > 0.0) {
                          tipPercentageFieldController.text =
                              (((totalAmount - billAmount) / billAmount) * 100)
                                  .toString();
                          tipAmountFieldController.text =
                              (totalAmount - billAmount).toString();
                        } else {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("Bill Amount < 0.0"),
                              ));
                        }
                      } else {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text("Invalid Total Amount."),
                            ));
                      }
                    } catch (exception) {
                      tipAmount = 0.0;
                      totalAmount = 0.0;

                      tipAmountFieldController.clear();
                      totalAmountFieldController.clear();

                      Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Invalid Total Amount. " +
                                exception.toString()),
                          ));
                    }
                  }),
              tipAmountTextField = new TextField(
                controller: tipAmountFieldController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  labelText: "Tip Amount",
                ),
                onChanged: (String value) {
                  try {
                    if (double.parse(value) >= 0.0 &&
                        (billAmount > 0.0 || totalAmount > 0.0)) {
                      tipAmount = double.parse(value);
                      if (billAmount > 0.0) {
                        totalAmount = billAmount + tipAmount;
                      }
                    }
                  } catch (exception) {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text(
                              "Invalid Tip Total. " + exception.toString()),
                        ));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
