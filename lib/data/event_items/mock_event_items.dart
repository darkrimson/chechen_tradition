import 'package:chechen_tradition/features/main/home/models/event_item.dart';
import 'package:flutter/material.dart';

final List<EventItem> events = [
  EventItem(
    title: 'Фестиваль культуры',
    description: 'Традиционный фестиваль чеченской культуры в Грозном',
    date: '10 мая',
    imageUrl:
        'https://avatars.mds.yandex.net/i?id=38ec9d827b48224cd2be94a02fcf35cec1a1a1404ff5ff4c-12405273-images-thumbs&n=13',
    color: Colors.orange.shade300,
  ),
  EventItem(
    title: 'День чеченского языка',
    description: 'Ежегодный праздник, посвященный чеченскому языку',
    date: '25 апреля',
    imageUrl:
        'https://avatars.mds.yandex.net/i?id=fa03a12da53f7bc7e8729963aefbd74ff1db3257-12720126-images-thumbs&n=13',
    color: Colors.indigo.shade300,
  ),
  EventItem(
    title: 'Выставка ремесел',
    description: 'Выставка традиционных чеченских ремесел и мастер-классы',
    date: '15 июня',
    imageUrl:
        'https://avatars.mds.yandex.net/i?id=80cccdd171b35275f2d41a683e3d5359-5233450-images-thumbs&n=13',
    color: Colors.teal.shade300,
  ),
  EventItem(
    title: 'Исторический форум',
    description: 'Международный форум по истории Северного Кавказа',
    date: '20 июля',
    imageUrl: 'https://www.grozny-inform.ru/LoadedFiles/0s16/12_w1000_h700.jpg',
    color: Colors.purple.shade300,
  )
];
