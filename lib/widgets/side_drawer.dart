import 'package:flutter/material.dart';
import 'package:weathermate/utilities/constants.dart';

// TODO: add custom nav pages (refresh location, choose location, advanced weather, settings)

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'My WeatherMate',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: accentColor,
                // image: DecorationImage(
                //     fit: BoxFit.fill,
                //     image: AssetImage('images/location_background.jpg')
              //)
            ),
          ),
          ListTile(
            leading: Icon(Icons.my_location, color: accentColor,),
            title: Text('Summary'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: Icon(Icons.assessment, color: accentColor,),
            title: Text('Detailed Weather'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: Icon(Icons.opacity, color: accentColor,),
            title: Text('Precipitation'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: Icon(Icons.border_color, color: accentColor,),
            title: Text('Feedback'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: accentColor,),
            title: Text('Settings'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}