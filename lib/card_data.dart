import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'card_content.dart';

class CardData {
  static const int DEFAULT_CARDS_COUNT = 52;
  static const String CUSTOM_CARDS_KEY = 'custom_cards';
  static final List<String> iconPaths = [
    'assets/image/icon/Icon1.jpg',
    'assets/image/icon/Icon2.jpg',
    'assets/image/icon/Icon3.jpg',
    'assets/image/icon/Icon4.jpg',
    'assets/image/icon/Icon5.jpg',
  ];

  static String getRandomIcon() {
    final random = Random();
    return iconPaths[random.nextInt(iconPaths.length)];
  }

  static Future<List<CardContent>> getAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get default 52 cards
    List<CardContent> defaultCards = _getDefaultCards();
    
    // Get custom cards
    List<CardContent> customCards = _getCustomCards(prefs);
    
    // Combine both lists
    return [...defaultCards, ...customCards];
  }

  // Keep the original 52 cards
  static List<CardContent> _getDefaultCards() {
    return [
      CardContent(
        number: 1,
        task: 'Làm: Hát một bài hát thiếu nhi với giọng opera',
        penalty: 'Phạt: Uống một ly nước chanh không đường',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 2,
        task: 'Làm: Nhảy một điệu nhảy "robot" trước mặt mọi người',
        penalty: 'Phạt: Phải mặc quần áo ngược trong vòng 10 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 3,
        task: 'Làm: Bắt chước tiếng kêu của 3 loài động vật',
        penalty: 'Phạt: Nhảy lò cò 10 vòng quanh phòng',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 4,
        task: 'Làm: Kể một câu chuyện cười',
        penalty: 'Phạt: Làm 20 cái hít đất',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 5,
        task: 'Làm: Tạo một bài rap ngẫu hứng về người bên cạnh',
        penalty: 'Phạt: Ăn một thìa tương ớt',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 6,
        task: 'Làm: Múa ballet trong 30 giây',
        penalty: 'Phạt: Đứng một chân trong 2 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 7,
        task: 'Làm: Giả giọng người nổi tiếng',
        penalty: 'Phạt: Không được nói chuyện trong 5 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 8,
        task: 'Làm: Vẽ chân dung người đối diện với mắt nhắm',
        penalty: 'Phạt: Nhảy dây 50 cái',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 9,
        task: 'Làm: Đọc ngược một câu dài',
        penalty: 'Phạt: Chạy tại chỗ 2 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 10,
        task: 'Làm: Tạo âm nhạc bằng đồ vật xung quanh',
        penalty: 'Phạt: Uống một ly nước đá',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 11,
        task: 'Làm: Diễn một cảnh phim nổi tiếng',
        penalty: 'Phạt: Làm 30 cái squat',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 12,
        task: 'Làm: Nói một câu bằng 5 thứ tiếng',
        penalty: 'Phạt: Ăn một quả chanh',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 13,
        task: 'Làm: Tạo một bài thơ về chủ đề được chọn',
        penalty: 'Phạt: Nhảy cao 20 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 14,
        task: 'Làm: Giả làm MC dẫn chương trình thời tiết',
        penalty: 'Phạt: Plank 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 15,
        task: 'Làm: Hát karaoke không có nhạc',
        penalty: 'Phạt: Đi vòng quanh phòng bằng gối',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 16,
        task: 'Làm: Diễn tả một bộ phim không dùng lời',
        penalty: 'Phạt: Nhảy burpee 10 cái',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 17,
        task: 'Làm: Tạo một câu chuyện với 5 từ ngẫu nhiên',
        penalty: 'Phạt: Đi bằng tay và chân 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 18,
        task: 'Làm: Bắt chước một nhân vật hoạt hình',
        penalty: 'Phạt: Ngồi xuống đứng lên 30 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 19,
        task: 'Làm: Hát một bài hát bằng tiếng kêu động vật',
        penalty: 'Phạt: Nhảy như ếch 10 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 20,
        task: 'Làm: Tạo một điệu nhảy mới',
        penalty: 'Phạt: Uống nước cam không đường',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 21,
        task: 'Làm: Diễn tả một nghề nghiệp bằng hành động',
        penalty: 'Phạt: Đi như cua 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 22,
        task: 'Làm: Kể chuyện cười bằng giọng khác',
        penalty: 'Phạt: Nhảy với một chân 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 23,
        task: 'Làm: Hát một bài hát ngược',
        penalty: 'Phạt: Làm 15 cái push-up',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 24,
        task: 'Làm: Tạo âm thanh động vật trong 30 giây',
        penalty: 'Phạt: Đứng im như tượng 2 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 25,
        task: 'Làm: Diễn tả một môn thể thao không dùng lời',
        penalty: 'Phạt: Chạy tại chỗ nâng cao gối 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 26,
        task: 'Làm: Hát một bài quảng cáo',
        penalty: 'Phạt: Nhảy jack 20 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 27,
        task: 'Làm: Tạo một câu slogan cho sản phẩm tưởng tượng',
        penalty: 'Phạt: Đi kiễng chân 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 28,
        task: 'Làm: Diễn tả cảm xúc bằng mặt trong 30 giây',
        penalty: 'Phạt: Nhảy dây tưởng tượng 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 29,
        task: 'Làm: Hát một bài hát chỉ bằng "la la la"',
        penalty: 'Phạt: Đi bộ tại chỗ 2 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 30,
        task: 'Làm: Tạo một điệu nhảy với bài hát đang hot',
        penalty: 'Phạt: Giữ tư thế cây cầu 30 giây',
        iconPath: getRandomIcon(),
      ),
      // Cards 31-52 continue with similar pattern
      CardContent(
        number: 31,
        task: 'Làm: Diễn tả một câu phim nổi tiếng',
        penalty: 'Phạt: Nhảy cao tại chỗ 15 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 32,
        task: 'Làm: Tạo một bài phát biểu hài hước',
        penalty: 'Phạt: Đi vòng quanh phòng bằng đầu gối',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 33,
        task: 'Làm: Hát một bài hát bằng giọng mũi',
        penalty: 'Phạt: Làm động tác gập bụng 20 cái',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 34,
        task: 'Làm: Diễn tả một trận đấu thể thao',
        penalty: 'Phạt: Nhảy như kanguru 10 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 35,
        task: 'Làm: Tạo một câu chuyện kinh dị ngắn',
        penalty: 'Phạt: Đi như chim cánh cụt 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 36,
        task: 'Làm: Hát một bài hát với miệng ngậm nước',
        penalty: 'Phạt: Làm động tác mountain climber 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 37,
        task: 'Làm: Diễn tả một ngày của bạn không dùng lời',
        penalty: 'Phạt: Đi như gấu 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 38,
        task: 'Làm: Tạo một bài quảng cáo về đôi giày',
        penalty: 'Phạt: Nhảy với hai chân 20 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 39,
        task: 'Làm: Hát một bài hát bằng tiếng động vật',
        penalty: 'Phạt: Đi như rùa 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 40,
        task: 'Làm: Diễn tả một nhân vật lịch sử',
        penalty: 'Phạt: Làm động tác jumping jack 20 cái',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 41,
        task: 'Làm: Tạo một câu chuyện về người bên cạnh',
        penalty: 'Phạt: Đi như vịt 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 42,
        task: 'Làm: Hát một bài hát với giọng trẻ con',
        penalty: 'Phạt: Nhảy dây tưởng tượng 2 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 43,
        task: 'Làm: Diễn tả một bộ phim hành động',
        penalty: 'Phạt: Đi như cua 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 44,
        task: 'Làm: Tạo một bài thơ về thức ăn',
        penalty: 'Phạt: Làm động tác squat jump 10 cái',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 45,
        task: 'Làm: Hát một bài hát với giọng robot',
        penalty: 'Phạt: Đi như khỉ 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 46,
        task: 'Làm: Diễn tả một câu chuyện cổ tích',
        penalty: 'Phạt: Nhảy lò cò 20 lần mỗi chân',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 47,
        task: 'Làm: Tạo một bài hát về màu sắc',
        penalty: 'Phạt: Đi như người máy 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 48,
        task: 'Làm: Hát một bài hát bằng tiếng kêu chim',
        penalty: 'Phạt: Làm động tác plank với chân nâng 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 49,
        task: 'Làm: Diễn tả một ngày mưa không dùng lời',
        penalty: 'Phạt: Đi như người say 30 giây',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 50,
        task: 'Làm: Tạo một câu chuyện về siêu anh hùng',
        penalty: 'Phạt: Nhảy như thỏ 15 lần',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 51,
        task: 'Làm: Hát một bài hát với giọng già',
        penalty: 'Phạt: Đi như người mẫu 1 phút',
        iconPath: getRandomIcon(),
      ),
      CardContent(
        number: 52,
        task: 'Làm: Diễn tả một chương trình game show',
        penalty: 'Phạt: Làm động tác star jump 15 cái',
        iconPath: getRandomIcon(),
      ),
    ];
  }

  static List<CardContent> _getCustomCards(SharedPreferences prefs) {
    final String? customCardsJson = prefs.getString(CUSTOM_CARDS_KEY);
    if (customCardsJson == null) return [];

    List<dynamic> decoded = json.decode(customCardsJson);
    return decoded.map((item) => CardContent(
      number: item['number'],
      task: item['task'],
      penalty: item['penalty'],
      iconPath: item['iconPath'],
    )).toList();
  }

  static Future<int> getNextCardNumber() async {
    final cards = await getAllCards();
    int highestNumber = 0;
    for (var card in cards) {
      if (card.number > highestNumber) {
        highestNumber = card.number;
      }
    }
    return highestNumber < DEFAULT_CARDS_COUNT ? DEFAULT_CARDS_COUNT + 1 : highestNumber + 1;
  }

  static Future<void> addCard(CardContent card) async {
    final prefs = await SharedPreferences.getInstance();
    List<CardContent> customCards = _getCustomCards(prefs);
    
    // Ensure the new card number is correct
    if (card.number <= DEFAULT_CARDS_COUNT) {
      card = CardContent(
        number: await getNextCardNumber(),
        task: card.task,
        penalty: card.penalty,
        iconPath: card.iconPath,
      );
    }
    
    customCards.add(card);

    final String encoded = json.encode(
      customCards.map((card) => {
        'number': card.number,
        'task': card.task,
        'penalty': card.penalty,
        'iconPath': card.iconPath,
      }).toList()
    );
    await prefs.setString(CUSTOM_CARDS_KEY, encoded);
  }
}
