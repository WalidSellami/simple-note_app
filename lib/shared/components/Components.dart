import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note/shared/cubit/Cubit.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required TextInputType type,
  required String text,
  required String? Function(String?)? validate,
  int? maxLines,
  int? minLines,
  int? maxLength,
  VoidCallback? onPress,
}) =>
    TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          text,
        ),
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(
        fontSize: 18.0,
      ),
      validator: validate,
      onTap: onPress ?? () {},
    );

Widget buildItemNote(Map list, context) => Dismissible(
      key: Key(list['id'].toString()),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 26,
          horizontal: 9,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: HexColor('242b34'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Text(
                  '${list['title']}',
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(
                '${list['content']}',
                // maxLines: 2,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  NoteCubit.get(context).deleteFromDataBase(id: list['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text.rich(
                        TextSpan(
                          text: '${list['title']} ',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          children: const [
                            TextSpan(
                              text: 'note deleted',
                              style: TextStyle(
                                fontSize: 16.5,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: HexColor('242b34'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  size: 30.0,
                ),
                tooltip: 'Remove',
              ),
            ),
            Text(
              '${list['date']}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction){
        NoteCubit.get(context).deleteFromDataBase(id: list['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text.rich(
                  TextSpan(
                    text: '${list['title']} ',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    children: const [
                      TextSpan(
                        text: 'note deleted',
                        style: TextStyle(
                          fontSize: 16.5,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
              ),
              backgroundColor: HexColor('242b34'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
