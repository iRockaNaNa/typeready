import '../models/test_config.dart';

/// One practice passage.
class Passage {
  const Passage({
    required this.id,
    required this.category,
    required this.title,
    required this.text,
  });

  final String id;
  final PassageCategory category;
  final String title;
  final String text;

  int get wordCount => text.split(RegExp(r'\s+')).length;
}

/// All v1 passages: 4 per category, 60-90 words each, written for this app.
/// No lorem ipsum — every passage reads like something a real job test
/// would put in front of you.
const List<Passage> passages = [
  // ---- General ----
  Passage(
    id: 'general_morning_coffee',
    category: PassageCategory.general,
    title: 'Morning Coffee',
    text:
        'Every morning starts the same way in our house. The alarm goes off '
        'at six, and the first thing I do is start the coffee maker before I '
        'even open my eyes all the way. While the coffee brews, I feed the '
        'cat, open the curtains, and check the weather for the day. By the '
        'time I sit down with a warm mug, the house is quiet and the day '
        'still feels full of promise. Those slow ten minutes are the best '
        'part of my whole morning.',
  ),
  Passage(
    id: 'general_library',
    category: PassageCategory.general,
    title: 'The Neighborhood Library',
    text:
        'Our neighborhood library is a small brick building at the end of '
        'Maple Street, but it holds more stories than you would ever guess. '
        'On Saturday mornings the reading room fills with kids doing '
        'homework, retirees finishing the daily crossword, and parents '
        'hunting for picture books. The librarian knows most visitors by '
        'name and always has a new recommendation waiting. I go there every '
        'week to return two books and leave with four, and I have never '
        'once regretted it.',
  ),
  Passage(
    id: 'general_park_walk',
    category: PassageCategory.general,
    title: 'A Walk in the Park',
    text:
        'After lunch I like to take a slow walk around the park near my '
        'apartment. The path loops past the duck pond, the playground, and a '
        'row of tall pine trees that smell wonderful after it rains. Joggers '
        'pass me on the left, dogs pull their owners toward every squirrel, '
        'and somewhere nearby a radio plays soft music. By the time I reach '
        'the bench by the fountain, my legs feel loose and my mind feels '
        'clear enough to face the rest of the day.',
  ),
  Passage(
    id: 'general_weekend_trip',
    category: PassageCategory.general,
    title: 'Planning a Weekend Trip',
    text:
        'We have been talking about a weekend road trip for months, and this '
        'Friday we are finally going to do it. The plan is simple: pack the '
        'car on Thursday night, leave right after breakfast, and drive about '
        'three hours to the lake. We will bring sandwiches, cold drinks, '
        'sunscreen, and a speaker for music along the way. The cabin has a '
        'small kitchen and a porch with a view of the water, and the '
        'forecast says the weekend will be warm and sunny the whole time.',
  ),

  // ---- Data Entry ----
  Passage(
    id: 'data_order_record',
    category: PassageCategory.dataEntry,
    title: 'Customer Order Record',
    text:
        'Order number 48219 was placed on March 4, 2026 by Maria Santos of '
        '214 Oak Street, Apartment 7, Denver, Colorado 80204. She ordered 3 '
        'blue notebooks at 4.99 each, 2 black pens at 2.49 each, and 1 desk '
        'lamp for 24.95. The order total is 44.90, and shipping is 5.95. Her '
        'phone number is 303-555-0184, and her email is '
        'maria.santos84@example.com. Please ship the order by March 7, 2026.',
  ),
  Passage(
    id: 'data_invoice',
    category: PassageCategory.dataEntry,
    title: 'Invoice Details',
    text:
        'Invoice 7712 was issued on April 18, 2026 to Thompson and Reed LLC, '
        '88 Harbor Road, Suite 300, Austin, Texas 78701. The invoice covers '
        '12 hours of consulting at 85.00 per hour, for a subtotal of '
        '1020.00. A service fee of 45.00 was added, and a discount of 102.00 '
        'was applied. The total amount due is 963.00, payable within 30 '
        'days. The payment reference is INV-7712-TR, and the billing contact '
        'is James Reed at 512-555-0139.',
  ),
  Passage(
    id: 'data_shipping_log',
    category: PassageCategory.dataEntry,
    title: 'Shipping Log Entry',
    text:
        'Tracking number 1Z8842W9031184567 left the Phoenix warehouse on May '
        '2, 2026 at 9:15 in the morning. The package weighs 4.2 pounds and '
        'measures 18 by 12 by 9 inches. It is headed to David Chen at 459 '
        'Pine Avenue, Portland, Oregon 97205. The delivery date is May 6, '
        '2026, and the shipping cost was 12.75. The sender is Bright Star '
        'Supplies, 1200 Industrial Way, Tempe, Arizona 85281, and the order '
        'number is BS-3391.',
  ),
  Passage(
    id: 'data_intake_form',
    category: PassageCategory.dataEntry,
    title: 'Patient Intake Form',
    text:
        'Patient Robert Alvarez, date of birth June 12, 1985, arrived for '
        'his appointment at 10:30 on Tuesday, November 3, 2026. His address '
        'is 77 Cedar Lane, Mesa, Arizona 85204, and his phone number is '
        '480-555-0126. His insurance member ID is AET-5521984, and his '
        'policy began on January 1, 2026. His emergency contact is Laura '
        'Alvarez at 480-555-0142. His height is 5 feet 11 inches, his '
        'weight is 192 pounds, and his blood pressure today is 128 over 84.',
  ),

  // ---- Customer Support ----
  Passage(
    id: 'support_order_status',
    category: PassageCategory.customerSupport,
    title: 'Order Status Update',
    text:
        'Hi Sarah, thanks so much for reaching out, and I am happy to check '
        'on your order for you. I can see that order 99184 shipped from our '
        'warehouse yesterday morning, and it is currently on its way to your '
        'address in Ohio. The tracking shows an estimated delivery date of '
        'Friday, June 12, 2026. You should receive a text message once the '
        'package is out for delivery. Please let me know if it has not '
        'arrived by Monday, and I will be glad to help further.',
  ),
  Passage(
    id: 'support_refund',
    category: PassageCategory.customerSupport,
    title: 'Refund Request Reply',
    text:
        'Hi James, thank you for letting us know about the problem with your '
        'headphones, and I am sorry they stopped working so soon after you '
        'bought them. I have processed a full refund of 59.99 to your '
        'original payment method, and you should see the money back in your '
        'account within 3 to 5 business days. You do not need to send the '
        'headphones back to us. If you would like a replacement instead, just '
        'reply to this message and I will arrange one right away.',
  ),
  Passage(
    id: 'support_password_reset',
    category: PassageCategory.customerSupport,
    title: 'Password Reset Help',
    text:
        'Hi Maria, I can help you get back into your account. First, please '
        'go to the sign-in page and click the link that says Forgot Password. '
        'We will send a reset link to the email address on your account, and '
        'it should arrive within a few minutes, so please check your spam '
        'folder if you do not see it. The link stays active for 60 minutes. '
        'Once you open it, you can choose a new password with at least 8 '
        'characters, including one number and one capital letter.',
  ),
  Passage(
    id: 'support_shipping_delay',
    category: PassageCategory.customerSupport,
    title: 'Shipping Delay Apology',
    text:
        'Hi David, thank you for your patience, and I am very sorry your '
        'package is arriving later than we promised. Bad weather slowed down '
        'the trucks on the route to your area, and the new delivery date is '
        'Wednesday, August 19, 2026. I have added a 10.00 credit to your '
        'account for the inconvenience, and you can use it on your next '
        'order. If you would like to change the delivery address or cancel '
        'the order instead, please let me know and I will take care of it.',
  ),
];

/// Passages for one category, in order.
List<Passage> passagesFor(PassageCategory category) =>
    passages.where((p) => p.category == category).toList();
