import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propertify_for_agents/models/property_model.dart';
import 'package:propertify_for_agents/resources/assets/propertify_icons.dart';
import 'package:propertify_for_agents/resources/colors/app_colors.dart';
import 'package:propertify_for_agents/resources/components/iconbox/customIconBox.dart';
import 'package:propertify_for_agents/resources/fonts/app_fonts/app_fonts.dart';
import 'package:propertify_for_agents/resources/constants/spaces%20&%20paddings/paddings.dart';
import 'package:propertify_for_agents/resources/constants/spaces%20&%20paddings/spaces.dart';
import 'package:propertify_for_agents/view_models/controllers/agent_view_model.dart';
import 'package:propertify_for_agents/view_models/controllers/property_view_model.dart';
import 'package:propertify_for_agents/views/add_property_screen/add_property_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../resources/components/buttons/custombuttons.dart';
import '../../resources/components/text_models/tagWidget.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Rx<PropertyModel> property;

  PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final agent = Get.find<AgentViewModel>().agent;
  bool showMap = true;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        setState(() {
          showMap = false;
        });
        // return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * .3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    '${widget.property.value.propertyCoverPicture!.path}'),
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * .3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                                stops: [0.0, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 40,
                            child: CustomIconBox(
                              boxheight: 40,
                              boxwidth: 40,
                              boxIcon: Icons.arrow_back,
                              radius: 8,
                              boxColor: Colors.transparent,
                              iconSize: 24,
                              iconColor: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 40,
                            child: Row(
                              children: [
                                CustomIconBox(
                                  boxheight: 40,
                                  boxwidth: 40,
                                  boxIcon: Icons.delete_outline,
                                  radius: 8,
                                  boxColor: Colors.white,
                                  iconSize: 24,
                                  iconColor: Colors.red,
                                  iconFunction: () async {
                                    await PropertyViewModel().deleteProperty(
                                        widget.property.value.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      customSpaces.verticalspace20,
                      Padding(
                        padding: customPaddings.horizontalpadding20,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1 / 1,
                          ),
                          itemBuilder: (context, index) {
                            if (index <
                                widget.property.value.propertyGalleryPictures!
                                    .length) {
                              // Check if the index is within the bounds of the list
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image(
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      '${widget.property.value.propertyGalleryPictures![index].path}'),
                                ),
                              );
                            } else {
                              // If index is out of bounds, you can display a placeholder or empty container
                              return Container(); // Empty container
                            }
                          },
                          itemCount: widget
                              .property.value.propertyGalleryPictures!.length,
                          shrinkWrap: true,
                        ),
                      ),
                      customSpaces.verticalspace20,
                      Padding(
                        padding: customPaddings.horizontalpadding20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    widget.property.value.propertyCategory,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                customSpaces.horizontalspace10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      PropertifyIcons.location,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    customSpaces.horizontalspace5,
                                    Text(
                                      widget.property.value.propertyCity,
                                      style: AppFonts.greyText14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            customSpaces.verticalspace5,
                            Text(
                              widget.property.value.propertyName,
                              style: AppFonts.SecondaryColorText24,
                            ),
                          ],
                        ),
                      ),
                      customSpaces.verticalspace10,
                      Padding(
                        padding: customPaddings.horizontalpadding20,
                        child: Row(
                          children: [
                            IconwithText(
                              contentIcon: PropertifyIcons.sqft,
                              contentText:
                                  '${widget.property.value.propertySqft} Sqft' ??
                                      '',
                            ),
                            customSpaces.horizontalspace20,
                            IconwithText(
                              contentIcon: PropertifyIcons.bed,
                              contentText:
                                  '${widget.property.value.propertyRooms} Rooms' ??
                                      '',
                            ),
                            customSpaces.horizontalspace20,
                            IconwithText(
                              contentIcon: Icons.shower_outlined,
                              contentText:
                                  '${widget.property.value.propertyBathrooms} Bathrooms' ??
                                      '',
                            ),
                          ],
                        ),
                      ),
                      customSpaces.verticalspace10,
                      Divider(),
                      customSpaces.verticalspace10,

                      Padding(
                        padding: customPaddings.horizontalpadding20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Overview',
                              style: AppFonts.SecondaryColorText20,
                            ),
                            customSpaces.verticalspace10,
                            Text(
                              widget.property.value.propertyDescription ?? '',
                              textAlign: TextAlign.justify,
                              style: AppFonts.greyText14,
                            ),
                          ],
                        ),
                      ),
                      customSpaces.verticalspace20,

                      Padding(
                        padding: customPaddings.horizontalpadding20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: AppFonts.SecondaryColorText20,
                            ),
                            customSpaces.verticalspace20,
                            showMap
                                ? GestureDetector(
                                    onTap: () async {
                                      await _launchDirections(
                                        double.parse(
                                            widget.property.value.latitude ??
                                                '0.0'),
                                        double.parse(
                                            widget.property.value.longitude ??
                                                '0.0'),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 200,
                                        child: GoogleMap(
                                          padding: EdgeInsets.all(10),
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                              double.parse(widget.property.value
                                                      .latitude ??
                                                  '0.0'),
                                              double.parse(widget.property.value
                                                      .longitude ??
                                                  '0.0'),
                                            ),
                                            zoom: 10,
                                          ),
                                          markers: <Marker>[
                                            Marker(
                                              markerId:
                                                  MarkerId('property_location'),
                                              position: LatLng(
                                                double.parse(widget.property
                                                        .value.latitude ??
                                                    '0.0'),
                                                double.parse(widget.property
                                                        .value.longitude ??
                                                    '0.0'),
                                              ),
                                              infoWindow: InfoWindow(
                                                title: widget.property.value
                                                    .propertyName,
                                              ),
                                            ),
                                          ].toSet(),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            customSpaces.verticalspace20,
                            Text(
                              'Features & Amentities',
                              style: AppFonts.SecondaryColorText20,
                            ),
                            customSpaces.verticalspace20,
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final amenities =
                                    widget.property.value.amenities;
                                final amenity = amenities![index];

                                Icon? amenityIcon = amenityIcons[amenity];

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    child: ListTile(
                                      leading:
                                          amenityIcon, // Use the icon as leading
                                      title: Text(amenity),
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  widget.property.value.amenities!.length,
                            ),
                            customSpaces.verticalspace20,
                            Text(
                              'Tags',
                              style: AppFonts.SecondaryColorText20,
                            ),
                            customSpaces.verticalspace20,
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1 / .5,
                              ),
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final tags = widget.property.value.tags;
                                return tagWidget(tagContent: tags![index]);
                              },
                              itemCount: widget.property.value.tags!.length,
                            ),
                            customSpaces.verticalspace20,
                          ],
                        ),
                      ),

                      //
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: customPaddings.horizontalpadding20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Price',
                              style: AppFonts.greyText14,
                            ),
                            Text(
                              widget.property.value.propertyPrice,
                              style: AppFonts.SecondaryColorText24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    customSpaces.horizontalspace20,
                    Expanded(
                      child: Container(
                        child: PrimaryButton(
                          // width: 100,
                          buttonText: 'Edit',
                          buttonFunction: () async {
                            Get.to(() =>
                                AddPropertyScreen(property: widget.property));
                            // await Future.delayed(Duration(seconds: 3));

                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchDirections(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}

Map<String, Icon> amenityIcons = {
  'Gym': Icon(Icons.fitness_center,
      color: AppColors.secondaryColor), // Specify color
  'Swimming Pool':
      Icon(Icons.pool, color: AppColors.secondaryColor), // Specify color
  'Parking': Icon(Icons.wifi, color: AppColors.secondaryColor),
  'Furnished': Icon(Icons.chair, color: AppColors.secondaryColor),
  'A/C': Icon(Icons.air, color: AppColors.secondaryColor),
};
