import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propertify_for_agents/models/property_model.dart';
import 'package:propertify_for_agents/resources/assets/propertify_icons.dart';
import 'package:propertify_for_agents/resources/colors/app_colors.dart';
import 'package:propertify_for_agents/resources/components/buttons/custombuttons.dart';
import 'package:propertify_for_agents/resources/components/iconbox/customIconBox.dart';
import 'package:propertify_for_agents/resources/components/image_picker/multi_image_picker.dart';
import 'package:propertify_for_agents/resources/components/image_picker/single_image_picker.dart';
import 'package:propertify_for_agents/resources/components/input_fileds/custom_Input_Fields.dart';
import 'package:propertify_for_agents/resources/components/input_fileds/custom_Multi_Line_Input_Field.dart';
import 'package:propertify_for_agents/resources/fonts/app_fonts/app_fonts.dart';
import 'package:propertify_for_agents/resources/constants/spaces%20&%20paddings/paddings.dart';
import 'package:propertify_for_agents/resources/constants/spaces%20&%20paddings/spaces.dart';
import 'package:propertify_for_agents/view_models/controllers/property_view_model.dart';
import 'package:propertify_for_agents/views/add_property_screen/custom_check_box.dart';
import 'package:propertify_for_agents/views/search_screen/search_screen.dart';

class AddPropertyScreen extends StatefulWidget {
  AddPropertyScreen(
      {Key? key,
      this.property,
      this.latitude = '',
      this.city = '',
      this.longitude = ''});
  final Rx<PropertyModel>? property;
  final String latitude;
  final String longitude;
  final String city;
  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  late PropertyViewModel propertyController;

  TextEditingController tagController = TextEditingController();
  int selectedTagIndex = -1;

  int selectedIndex = -1;
  bool showMap = true;

  @override
  void initState() {
    super.initState();
    propertyController = Get.put(
      PropertyViewModel(property: widget.property),
    );
    selectedIndex = propertyController.categories.indexWhere(
        (element) => element == propertyController.selectedCategory.value);
    propertyController.propertyLatitude.text = widget.latitude;
    propertyController.propertyLongitude.text = widget.longitude;
    propertyController.propertyCity.text = widget.city;
  }

  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        setState(() {
          showMap = false;
        });
      },
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
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
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconBox(
                              iconFunction: () => Get.back(),
                              boxheight: 40,
                              boxwidth: 40,
                              boxIcon: Icons.arrow_back,
                              radius: 8,
                              boxColor: Colors.grey.shade300,
                              iconSize: 20,
                            ),
                            customSpaces.horizontalspace20,
                            Text(
                              "Add New Property",
                              style: AppFonts.SecondaryColorText20,
                            ),
                          ],
                        ),
                      ),
                      customSpaces.horizontalspace20,
                      Container(child: CircleAvatar()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    // key: propertyController.propertyformkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customSpaces.verticalspace20,
                        Padding(
                          padding: customPaddings.horizontalpadding20,
                          child: GetX<PropertyViewModel>(builder: (_) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInputField(
                                  fieldIcon: PropertifyIcons.home,
                                  hintText: 'Enter Property Name',
                                  controller: propertyController.propertyName,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyData(
                                  //           value, 'Property Name');
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: GridView.builder(
                                    padding: EdgeInsets.all(0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1 / 1,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemCount: propertyController
                                            ?.categories?.length ??
                                        0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final category = propertyController
                                          ?.categories?[index];
                                      if (category == null) return SizedBox();

                                      final isSelected = selectedIndex == index;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                          propertyController.selectedCategory
                                              .value = category;
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryColor
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primaryColor
                                                  : Colors.grey.shade400,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                size: 18,
                                                _getIconForCategory(category),
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                category,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                CustomColorButton(
                                  buttonText: 'Choose Location',
                                  buttonColor: Colors.grey.shade600,
                                  buttonFunction: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SearchScreen(
                                        propertyLatitude:
                                            propertyController.propertyLatitude,
                                        propertyLongitude: propertyController
                                            .propertyLongitude,
                                        propertyCity:
                                            propertyController.propertyCity,
                                        isPop: true,
                                      ),
                                    ));
                                  },
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  editable: false,
                                  fieldIcon: Icons.pin_drop,
                                  hintText: 'Latitude',
                                  controller:
                                      propertyController.propertyLatitude,
                                  keyboardType: TextInputType.number,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyPrice(value);
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  editable: false,
                                  fieldIcon: Icons.pin_drop,
                                  hintText: 'Longitude',
                                  controller:
                                      propertyController.propertyLongitude,
                                  keyboardType: TextInputType.number,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyPrice(value);
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomInputField(
                                        fieldIcon: PropertifyIcons.bed,
                                        hintText: 'Enter Rooms',
                                        controller:
                                            propertyController.propertyRooms,
                                        keyboardType: TextInputType.number,
                                        // validator: (value) {
                                        //   return propertyController
                                        //       .validatePropertyPrice(value);
                                        // },
                                      ),
                                    ),
                                    customSpaces.horizontalspace10,
                                    Expanded(
                                      child: CustomInputField(
                                        fieldIcon: Icons.shower_outlined,
                                        hintText: 'Enter Bathrooms',
                                        controller: propertyController
                                            .propertyBathrooms,
                                        keyboardType: TextInputType.number,
                                        // validator: (value) {
                                        //   return propertyController
                                        //       .validatePropertyPrice(value);
                                        // },
                                      ),
                                    ),
                                  ],
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  fieldIcon: PropertifyIcons.sqft,
                                  hintText: 'Enter Sqft',
                                  controller: propertyController.propertySqft,
                                  keyboardType: TextInputType.number,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyPrice(value);
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  fieldIcon: Icons.currency_rupee_sharp,
                                  hintText: 'Enter Property Price',
                                  controller: propertyController.propertyPrice,
                                  keyboardType: TextInputType.number,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyPrice(value);
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  fieldIcon: Icons.location_city,
                                  hintText: 'Enter Property City',
                                  controller: propertyController.propertyCity,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyData(
                                  //           value, 'Property City');
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  fieldIcon: Icons.map_outlined,
                                  hintText: 'Enter Property State',
                                  controller: propertyController.propertyState,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyData(
                                  //           value, 'Property State');
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                CustomInputField(
                                  fieldIcon: Icons.pin_outlined,
                                  hintText: 'Enter Property Pincode',
                                  controller:
                                      propertyController.propertyPincode,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyPincode(value);
                                  // },
                                  keyboardType: TextInputType.number,
                                ),
                                customSpaces.verticalspace20,
                                Text(
                                  "Property Cover Picture",
                                  style: AppFonts.SecondaryColorText16,
                                ),
                                customSpaces.verticalspace20,
                                SingleImagePickerWidget(
                                  onImageSelected: (File? image) {
                                    if (widget.property?.value == null) {
                                      setState(() {
                                        propertyController
                                            .propertyCoverPicture = image;
                                      });
                                    } else {
                                      setState(() {
                                        propertyController.updatedCoverPicture =
                                            image;
                                      });
                                    }
                                  },
                                  initialImageUrl: widget.property?.value
                                              ?.propertyCoverPicture !=
                                          null
                                      ? '${widget.property!.value!.propertyCoverPicture!.path}'
                                      : null,
                                ),
                                customSpaces.verticalspace20,
                                MultiImagePickerWidget(
                                  onImagesSelected: (images, removedImageUrls) {
                                    propertyController.propertyGalleryPictures =
                                        images;
                                    propertyController.removedImageUrls =
                                        removedImageUrls;
                                  },
                                  onNewImages: (images) {
                                    propertyController.newGalleryPictures =
                                        images;
                                  },
                                  initialImageUrls: widget
                                      .property?.value.propertyGalleryPictures
                                      ?.map((image) => image.path)
                                      .toList(),
                                  initialRemovedImageUrls: [],
                                ),
                                customSpaces.verticalspace20,
                                Text(
                                  "Overview",
                                  style: AppFonts.SecondaryColorText16,
                                ),
                                customSpaces.verticalspace20,
                                CustomMultiLineInputField(
                                  hintText: '',
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 8,
                                  controller:
                                      propertyController.propertyDescription,
                                  // validator: (value) {
                                  //   return propertyController
                                  //       .validatePropertyData(
                                  //           value, 'Property Overview');
                                  // },
                                ),
                                customSpaces.verticalspace20,
                                Text(
                                  "Features & Amenities",
                                  style: AppFonts.SecondaryColorText16,
                                ),
                                customSpaces.verticalspace10,
                                Wrap(
                                  spacing: 10,
                                  children: amenitiesList.map((amenity) {
                                    final isChecked = propertyController
                                        .amenities
                                        .contains(amenity);
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isChecked) {
                                            propertyController.amenities
                                                .remove(amenity);
                                          } else {
                                            propertyController.amenities
                                                .add(amenity);
                                          }
                                          print(propertyController.amenities);
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isChecked
                                                  ? Colors.black
                                                  : Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomCheckbox(
                                              isChecked: isChecked,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value) {
                                                    propertyController.amenities
                                                        .add(amenity);
                                                  } else {
                                                    propertyController.amenities
                                                        .remove(amenity);
                                                  }
                                                  print(propertyController
                                                      .amenities);
                                                });
                                              },
                                            ),
                                            SizedBox(width: 5),
                                            Text(amenity,
                                                style: isChecked
                                                    ? AppFonts
                                                        .SecondaryColorText14
                                                    : AppFonts.greyText14),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                customSpaces.verticalspace20,
                                CustomColorButton(
                                  buttonText: 'Add Tags',
                                  buttonColor: AppColors.secondaryColor,
                                  buttonFunction: () {
                                    selectedTagIndex = -1;
                                    _showTagBottomSheet('');
                                  },
                                ),
                                customSpaces.verticalspace10,
                                GetBuilder<PropertyViewModel>(
                                  builder: (model) {
                                    return Wrap(
                                      spacing: 10,
                                      children: List.generate(model.tags.length,
                                          (index) {
                                        final tag = model.tags[index];
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                selectedTagIndex = index;
                                                _showTagBottomSheet(tag);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    customSpaces
                                                        .horizontalspace5,
                                                    Icon(Icons.tag),
                                                    SizedBox(width: 5),
                                                    Text(tag),
                                                    SizedBox(width: 5),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          model.tags
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade100,
                                                          radius: 15,
                                                          child: Icon(
                                                            Icons.close_rounded,
                                                            color: Colors.red,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                ),
                                customSpaces.verticalspace20,
                              ],
                            );
                          }),
                        ),
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
                        child: PrimaryButton(
                          buttonText:
                              widget.property == null ? 'Submit' : 'Update',
                          buttonFunction: () async {
                            if (widget.property == null) {
                              await propertyController.addPropertyData();
                            } else {
                              final propertyId = widget.property!.value.id;

                              if (propertyId != null) {
                                await propertyController
                                    .updatePropertyData(widget.property!);
                                // print('Updating success');
                              } else {
                                print(
                                    'Unable to update property - ID is null.');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTagBottomSheet(String initialTag) {
    tagController.text = initialTag;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                  fieldIcon: Icons.tag,
                  controller: tagController,
                  hintText: 'Please enter tag',
                ),
                customSpaces.verticalspace10,
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        buttonText: initialTag.isEmpty ? 'Add' : 'Update',
                        buttonFunction: () {
                          final updatedTag = tagController.text;
                          if (updatedTag.isNotEmpty) {
                            setState(() {
                              if (initialTag.isEmpty) {
                                propertyController.tags.add(updatedTag);
                              } else {
                                propertyController.tags[selectedTagIndex] =
                                    updatedTag;
                              }
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'House':
        return PropertifyIcons.home;
      case 'Apartment':
        return Icons.apartment_rounded;
      case 'Office':
        return Icons.work_outline_rounded;
      case 'Other':
        return Icons.category_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  void dispose() {
    super.dispose();
    // propertyController.dispose();
    propertyController.onClose();
  }
}
