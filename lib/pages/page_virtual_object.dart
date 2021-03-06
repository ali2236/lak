import 'package:datafusion/widgets/widget_form_input_double.dart';
import 'package:datafusion/widgets/widget_virtual_temp_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class VirtualObjectPage extends StatefulWidget {
  @override
  _VirtualObjectPageState createState() => _VirtualObjectPageState();
}

class _VirtualObjectPageState extends State<VirtualObjectPage> {
  var tempsList = List<DropdownMenuItem>.generate(500, (i) {
    var value = i + 1.0;
    return DropdownMenuItem<double>(
      value: value,
      child: Text(value.toString()),
    );
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: simulation,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: Hero(
                tag: 'جسم مجازی',
                child: Text('جسم مجازی'),
              ),
              titleSpacing: 4.0,
            ),
            body: ListView(
              children: <Widget>[
                SizedBox(
                  height: 250,
                  child: VirtualTempDisplay(
                    key: UniqueKey(),
                    temps: simulation.object.temps,
                    temp: simulation.object.surfaceTemps,
                    min: simulation.object.minTemp,
                    max: simulation.object.maxTemp,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('ریست کردن جسم'),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        await simulation.run();
                        setState(() {});
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text('طول جسم'),
                  subtitle: Text(simulation.object.surfaceTemps.n.toString() +
                      ' تا ستون در جسم فعلی'),
                  trailing: DropdownButton(
                    value: simulation.rows,
                    onChanged: (value) => simulation.rows = value,
                    items: List<DropdownMenuItem>.generate(20, (i) {
                      var value = i + 1;
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }),
                  ),
                ),
                ListTile(
                  title: Text('عرض جسم'),
                  subtitle: Text(simulation.object.surfaceTemps.m.toString() +
                      ' تا سطر در جسم فعلی'),
                  trailing: DropdownButton(
                    value: simulation.columns,
                    onChanged: (value) => simulation.columns = value,
                    items: List<DropdownMenuItem>.generate(20, (i) {
                      var value = i + 1;
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }),
                  ),
                ),
                ListTile(
                  title: Text('سرعت بیرون دادن اطلاعات'),
                  subtitle: Text('داده ها از جسم به سنسورها push می شوند'),
                  trailing: DropdownButton(
                    value: simulation.emitRate,
                    onChanged: (value) {
                      setState(() {
                        simulation.emitRate = value;
                      });
                    },
                    items: List<DropdownMenuItem>.generate(50, (i) {
                      var value = (i + 1) * 20;
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }),
                  ),
                ),
                Form(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Text('کمترین دمای یک نقطه'),
                              SizedBox(width: 4),
                              Text(
                                '(' 'برابر با ' +
                                    simulation.object.minTemp.toString() +
                                    ' برای جسم فعلی' ')',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        subtitle: DoubleFormInput(
                          label: 'کمترین دما',
                          initialValue: simulation.minTemp,
                          onChange: (v) {
                            simulation.minTemp = v;
                          },
                          validator: (v) {
                            if (v > simulation.maxTemp)
                              return 'کمترین دما نمی تواند از بیشترین دما بیشتر باشد';
                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Text('بیشترین دمای یک نقطه'),
                              SizedBox(width: 4),
                              Text(
                                '(' 'برابر با ' +
                                    simulation.object.maxTemp.toString() +
                                    ' برای جسم فعلی' ')',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        subtitle: DoubleFormInput(
                          label: 'بیشترین دما',
                          initialValue: simulation.maxTemp,
                          onChange: (v) {
                            simulation.maxTemp = v;
                          },
                          validator: (v) {
                            if (v < simulation.minTemp)
                              return 'بیشترین دما نمی تواند از کمترین دما کمتر باشد';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
