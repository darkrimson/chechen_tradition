import 'package:chechen_tradition/features/main/home/models/event_item.dart';
import 'package:flutter/material.dart';

final List<EventItem> events = [
  EventItem(
    title: 'День чеченского языка',
    description: 'Ежегодный праздник, посвященный чеченскому языку',
    date: '25 апреля',
    imageUrl: 'assets/images/chechen_language.jpg',
    color: Colors.indigo.shade300,
  ),
  EventItem(
    title: 'Фестиваль культуры',
    description: 'Традиционный фестиваль чеченской культуры в Грозном',
    date: '10 мая',
    imageUrl: 'assets/images/festival.jpg',
    color: Colors.orange.shade300,
  ),
  EventItem(
    title: 'Выставка ремесел',
    description: 'Выставка традиционных чеченских ремесел и мастер-классы',
    date: '15 июня',
    imageUrl: 'assets/images/crafts.jpg',
    color: Colors.teal.shade300,
  ),
  EventItem(
    title: 'Исторический форум',
    description: 'Международный форум по истории Северного Кавказа',
    date: '20 июля',
    imageUrl: 'assets/images/history.jpg',
    color: Colors.purple.shade300,
  ),
  EventItem(
    title: 'Этнический концерт',
    description: 'Концерт традиционной чеченской музыки',
    date: '5 августа',
    imageUrl: 'assets/images/music.jpg',
    color: Colors.deepOrange.shade300,
  ),
];
