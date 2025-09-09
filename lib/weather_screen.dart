import 'dart:convert';
import 'dart:ui';
import 'package:weather_app/secrets.dart';
import "package:weather_app/weather_forecast_item.dart";
import "package:weather_app/additional_info_item.dart";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({ super.key });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  // late double temp;

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentWeather();
  // }

  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async{
    String cityName = 'Surat';
    try{
      final res = await http.get(
        Uri.parse('https://pro.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey')
      );

      final data = jsonDecode(res.body);

      if(data['cod']!='200'){
        throw data['message'];
      }

      return data;

      // setState(() {
      //   temp = data['list'][0]['main']['temp'];
      // });
    }
    catch (err){
      throw err.toString();
    }
  }

  IconData getMyIcon(currentSky){
    if(currentSky=='Clouds'){
      return Icons.cloud;
    }else if(currentSky=='Rain'){
      return Icons.cloudy_snowing;
    }else {
      return Icons.sunny;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                weather = getCurrentWeather();
              });
            }, 
            icon: Icon(Icons.refresh)
          )
        ],
      ),

      //body: temp==0 ? const CircularProgressIndicator() : ...

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          //print(snapshot);
          //print(snapshot.runtimeType);
          
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: const CircularProgressIndicator.adaptive()
            );
          }

          if(snapshot.hasError){
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            );
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpped = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemp K",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 16,),
                                Icon(
                                  getMyIcon(currentSky),
                                  size: 48,
                                ),
                                Text(
                                  "$currentSky",
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8,),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       //if you have reurn multiple widget per index
                  //       // for(int i = 0; i<39; i++) ...[
                  //       //   HourlyForecastitem(
                  //       //       time: data['list'][i+1]['dt'].toString(),
                  //       //       icon: getMyIcon(data['list'][i+1]['weather'][0]['main'].toString()),
                  //       //       temperature: data['list'][i+1]['main']['temp'].toString(),
                  //       //   )
                  //       // ]

                  //       //if you have to return single widget per index
                  //       for(int i = 0; i<39; i++) 
                  //         HourlyForecastitem(
                  //             time: data['list'][i+1]['dt'].toString(),
                  //             icon: getMyIcon(data['list'][i+1]['weather'][0]['main'].toString()),
                  //             temperature: data['list'][i+1]['main']['temp'].toString(),
                  //         )
                  //       ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 39,
                      itemBuilder: (context, i){
                        final hourlyForecast = data['list'][i+1];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecastitem(
                          time: DateFormat.j().format(time),
                          icon: getMyIcon(hourlyForecast['weather'][0]['main'].toString()),
                          temperature: '${hourlyForecast['main']['temp']} K',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpped.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '$currentPressure',
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

