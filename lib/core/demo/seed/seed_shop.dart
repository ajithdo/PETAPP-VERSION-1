import 'seed.dart';

/// Shop categories (spec 7.10). No prescription-only medicines.
const productCategories = [
  'food',
  'treats',
  'toys',
  'grooming',
  'health_hygiene',
  'beds',
  'collars_leashes',
  'bowls_feeders',
  'litter_cat',
  'bird_food_cages',
  'rabbit_care',
  'clothing',
  'travel',
];

class _P {
  const _P(this.id, this.name, this.brand, this.cat, this.species, this.price, this.mrp,
      {this.sub, this.life = const ['all'], this.size = const ['all'], this.packKg,
      this.seller = 'seller_1', this.partner, this.desc = '', this.ingredients});
  final String id;
  final String name;
  final String brand;
  final String cat;
  final List<String> species;
  final int price;
  final int mrp;
  final String? sub;
  final List<String> life;
  final List<String> size;
  final double? packKg;
  final String seller;
  final String? partner;
  final String desc;
  final String? ingredients;
}

const _products = <_P>[
  _P('prod_lab_adult_10', 'Adult Large Breed Dry Food, Chicken-free Lamb & Rice 10 kg', 'Gharelu Paws', 'food', ['dog'], 3899, 4499,
      sub: 'dry', life: ['adult'], size: ['large', 'giant'], packKg: 10, seller: 'seller_1',
      desc: 'Complete food for adult large breeds. Lamb and rice, no chicken, for dogs with chicken allergy.',
      ingredients: 'Lamb meal, rice, oats, fish oil, vitamins and minerals'),
  _P('prod_puppy_3', 'Puppy Starter Dry Food 3 kg', 'Gharelu Paws', 'food', ['dog'], 1299, 1499,
      sub: 'puppy', life: ['puppy'], packKg: 3, seller: 'seller_1',
      desc: 'Small kibble with DHA for growing puppies.', ingredients: 'Chicken, rice, egg, DHA, calcium'),
  _P('prod_senior_dog_7', 'Senior Joint Care Dry Food 7 kg', 'BhojanBuddy', 'food', ['dog'], 3299, 3799,
      sub: 'senior', life: ['senior'], size: ['medium', 'large', 'giant'], packKg: 7, seller: 'seller_2',
      desc: 'With glucosamine for older dogs with stiff joints.', ingredients: 'Fish, brown rice, glucosamine, chondroitin'),
  _P('prod_dog_wet_12', 'Chicken Chunks in Gravy (12 pouches)', 'BhojanBuddy', 'food', ['dog'], 699, 840,
      sub: 'wet', seller: 'seller_2', desc: 'Tasty wet food topper for adult dogs.'),
  _P('prod_cat_dry_3', 'Indoor Cat Dry Food Ocean Fish 3 kg', 'KittyKalpa', 'food', ['cat'], 1599, 1899,
      sub: 'dry', life: ['adult'], packKg: 3, seller: 'seller_3', desc: 'Hairball control for indoor cats.'),
  _P('prod_kitten_1', 'Kitten Growth Dry Food 1.2 kg', 'KittyKalpa', 'food', ['cat'], 749, 899,
      sub: 'kitten', life: ['puppy'], packKg: 1.2, seller: 'seller_3', desc: 'For kittens up to 12 months.'),
  _P('prod_cat_wet_12', 'Tuna in Jelly (12 pouches)', 'KittyKalpa', 'food', ['cat'], 649, 780,
      sub: 'wet', seller: 'seller_3', desc: 'Wet food for adult cats.'),
  _P('prod_cat_senior_renal', 'Senior Cat Kidney Care Food 2 kg', 'KittyKalpa', 'food', ['cat'], 1899, 2199,
      sub: 'senior', life: ['senior'], packKg: 2, seller: 'seller_3', desc: 'Low phosphorus recipe for senior cats. Ask your vet first.'),
  _P('prod_bird_seed_1', 'Cockatiel Seed Mix 1 kg', 'ChirpChoice', 'bird_food_cages', ['bird'], 349, 399,
      packKg: 1, seller: 'seller_4', desc: 'Millet, canary seed and oats for cockatiels.'),
  _P('prod_bird_cage_m', 'Medium Bird Cage with Perches', 'ChirpChoice', 'bird_food_cages', ['bird'], 2499, 2999,
      seller: 'seller_4', desc: 'Powder-coated cage, 60 x 40 x 70 cm.'),
  _P('prod_rabbit_hay_1', 'Timothy Hay 1 kg', 'HopHarvest', 'rabbit_care', ['rabbit'], 499, 599,
      packKg: 1, seller: 'seller_4', desc: 'High-fibre hay, the base of a rabbit diet.'),
  _P('prod_rabbit_pellets', 'Adult Rabbit Pellets 1 kg', 'HopHarvest', 'rabbit_care', ['rabbit'], 449, 520,
      packKg: 1, seller: 'seller_4', desc: 'Balanced pellets for adult rabbits.'),
  _P('prod_rabbit_hutch', 'Indoor Rabbit Pen', 'HopHarvest', 'rabbit_care', ['rabbit'], 3499, 3999,
      seller: 'seller_5', desc: 'Foldable 8-panel pen.'),
  _P('prod_treat_chew', 'Dental Chew Sticks (28 pcs)', 'WagWorks', 'treats', ['dog'], 399, 499,
      seller: 'seller_1', desc: 'Helps reduce tartar.'),
  _P('prod_treat_cat', 'Creamy Cat Treats (10 tubes)', 'KittyKalpa', 'treats', ['cat'], 299, 349,
      seller: 'seller_3', desc: 'Lickable treats.'),
  _P('prod_treat_training', 'Training Bites Peanut Butter 200 g', 'WagWorks', 'treats', ['dog'], 249, 299,
      life: ['puppy', 'adult'], seller: 'seller_1', desc: 'Small soft treats for training.'),
  _P('prod_toy_rope', 'Cotton Rope Tug Toy', 'WagWorks', 'toys', ['dog'], 199, 249, seller: 'seller_5', desc: 'Durable rope toy.'),
  _P('prod_toy_ball', 'Squeaky Rubber Ball (2 pack)', 'WagWorks', 'toys', ['dog'], 249, 299, seller: 'seller_5', desc: 'Bright, floats in water.'),
  _P('prod_toy_wand', 'Feather Wand Cat Toy', 'KittyKalpa', 'toys', ['cat'], 199, 229, seller: 'seller_5', desc: 'Interactive play wand.'),
  _P('prod_toy_bird', 'Bird Foraging Toy', 'ChirpChoice', 'toys', ['bird'], 299, 349, seller: 'seller_4', desc: 'Keeps parrots busy.'),
  _P('prod_shampoo', 'Gentle Oatmeal Dog Shampoo 500 ml', 'NestNook', 'grooming', ['dog'], 399, 450, seller: 'seller_6', desc: 'Soap-free, for sensitive skin.'),
  _P('prod_brush', 'Deshedding Brush', 'NestNook', 'grooming', ['dog', 'cat'], 549, 699, seller: 'seller_6', desc: 'Removes loose undercoat.'),
  _P('prod_nail', 'Pet Nail Clipper', 'NestNook', 'grooming', ['dog', 'cat', 'rabbit'], 299, 349, seller: 'seller_6', desc: 'With safety guard.'),
  _P('prod_tick_comb', 'Tick & Flea Comb', 'NestNook', 'health_hygiene', ['dog', 'cat'], 149, 199, seller: 'seller_6', desc: 'Fine-tooth steel comb.'),
  _P('prod_bed_l', 'Orthopaedic Dog Bed Large', 'NestNook', 'beds', ['dog'], 3999, 4999, size: ['large', 'giant'], seller: 'seller_6', desc: 'Memory foam, washable cover. Good for older joints.'),
  _P('prod_bed_cat', 'Cosy Cat Cave Bed', 'NestNook', 'beds', ['cat'], 1299, 1599, seller: 'seller_6', desc: 'Soft felt cave.'),
  _P('prod_harness', 'No-pull Harness (M/L)', 'WagWorks', 'collars_leashes', ['dog'], 899, 1099, size: ['medium', 'large'], seller: 'seller_5', desc: 'Front clip reduces pulling.'),
  _P('prod_leash', 'Reflective Leash 1.5 m', 'WagWorks', 'collars_leashes', ['dog'], 449, 549, seller: 'seller_5', desc: 'Padded handle, reflective stitching.'),
  _P('prod_bowl', 'Steel Bowl Set (2)', 'NestNook', 'bowls_feeders', ['dog', 'cat'], 349, 399, seller: 'seller_6', desc: 'Anti-skid base.'),
  _P('prod_litter', 'Clumping Cat Litter 10 kg', 'KittyKalpa', 'litter_cat', ['cat'], 899, 1049, packKg: 10, seller: 'seller_3', desc: 'Low dust, odour control.'),
  // Affiliate partner listings (10)
  _P('prod_aff_feeder', 'Automatic Smart Feeder', 'FeedLoop', 'bowls_feeders', ['dog', 'cat'], 6999, 8499, partner: 'partner_1', desc: 'Schedule meals from your phone.'),
  _P('prod_aff_fountain', 'Pet Water Fountain 2 L', 'FeedLoop', 'bowls_feeders', ['cat', 'dog'], 1999, 2499, partner: 'partner_1', desc: 'Filtered running water.'),
  _P('prod_aff_raincoat', 'Dog Raincoat with Hood', 'MonsoonMutt', 'clothing', ['dog'], 699, 899, partner: 'partner_2', desc: 'For rainy-season walks.'),
  _P('prod_aff_tshirt', 'Cotton Pet T-shirt', 'MonsoonMutt', 'clothing', ['dog', 'cat'], 399, 499, partner: 'partner_2', desc: 'Breathable summer wear.'),
  _P('prod_aff_carrier', 'Airline-style Pet Carrier', 'TripTails', 'travel', ['cat', 'dog', 'rabbit'], 2799, 3299, partner: 'partner_3', desc: 'Ventilated hard carrier.'),
  _P('prod_aff_seatbelt', 'Car Seat Belt for Dogs', 'TripTails', 'travel', ['dog'], 349, 449, partner: 'partner_3', desc: 'Adjustable safety tether.'),
  _P('prod_aff_cooling', 'Cooling Mat for Summer', 'TripTails', 'beds', ['dog', 'cat'], 1499, 1899, partner: 'partner_3', desc: 'Pressure-activated cooling gel. Great for Indian summers.'),
  _P('prod_aff_bird_bath', 'Bird Bath Tub', 'FeedLoop', 'bird_food_cages', ['bird'], 299, 349, partner: 'partner_1', desc: 'Clip-on bath for cages.'),
  _P('prod_aff_scratcher', 'Cardboard Cat Scratcher', 'MonsoonMutt', 'toys', ['cat'], 499, 599, partner: 'partner_2', desc: 'Saves your sofa.'),
  _P('prod_aff_gps_collar', 'GPS Collar Tracker', 'TripTails', 'collars_leashes', ['dog'], 5999, 6999, partner: 'partner_3', desc: 'Live location and activity (works with Connected devices).'),
];

void seedShop(Add add, DateTime now) {
  final r = SeedRandom(11);
  final sellers = [
    ('seller_1', 'Tail Treats Traders', 'Hyderabad', 'u_seller', 'approved'),
    ('seller_2', 'BhojanBuddy Store', 'Bengaluru', null, 'approved'),
    ('seller_3', 'Meow Mart India', 'Mumbai', null, 'approved'),
    ('seller_4', 'Feather & Fur Supplies', 'Chennai', null, 'approved'),
    ('seller_5', 'Playful Pets Depot', 'Pune', null, 'approved'),
    ('seller_6', 'NestNook Home', 'Delhi NCR', null, 'approved'),
    ('seller_pending', 'Desi Pet Bazaar', 'Hyderabad', null, 'pending'),
  ];
  var phone = 71;
  for (final s in sellers) {
    add('sellers', s.$1, {
      'name': s.$2,
      'city': s.$3,
      'uid': s.$4,
      'status': s.$5,
      'phone': demoPhone(phone++),
      'email': '${s.$1}@example.com',
      'gstin': 'SAMPLE-GSTIN',
      'returnPolicy': '7-day easy returns on unopened items',
      'rating': s.$5 == 'pending' ? 0 : (40 + r.next(9)) / 10,
      'kycDocs': ['PAN (SAMPLE)', 'Cancelled cheque (SAMPLE)'],
      'createdAt': now.subtract(Duration(days: 300 - r.next(150))),
    });
  }
  for (final p in [
    ('partner_1', 'FeedLoop Online', 'https://feedloop.example.com', 6),
    ('partner_2', 'MonsoonMutt Store', 'https://monsoonmutt.example.com', 8),
    ('partner_3', 'TripTails Shop', 'https://triptails.example.com', 7),
  ]) {
    add('partners', p.$1, {
      'name': p.$2,
      'url': p.$3,
      'commissionPercent': p.$4,
      'clicks': 20 + r.next(200),
      'status': 'approved',
    });
  }
  for (final p in _products) {
    add('products', p.id, {
      'name': p.name,
      'brand': p.brand,
      'category': p.cat,
      'subcategory': p.sub,
      'species': p.species,
      'lifeStages': p.life,
      'breedSizes': p.size,
      'price': p.price,
      'mrp': p.mrp,
      'stock': p.partner == null ? 5 + r.next(80) : null,
      'sellerId': p.partner == null ? p.seller : null,
      'partnerId': p.partner,
      'affiliateUrl': p.partner == null ? null : 'https://example.com/product/${p.id}',
      'rating': (36 + r.next(13)) / 10,
      'reviewCount': 3 + r.next(60),
      'description': p.desc,
      'ingredients': p.ingredients,
      'packKg': p.packKg,
      'imageSeed': r.next(8),
      'deliveryDays': 2 + r.next(4),
      'returnable': p.cat != 'food' && p.cat != 'treats',
      'active': true,
      'createdAt': now.subtract(Duration(days: 60 + r.next(200))),
    });
  }
}
