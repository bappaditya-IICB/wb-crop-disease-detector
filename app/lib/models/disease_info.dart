// Disease information database
// All disease details are in English, Bengali, and Hindi
// Treatment recommendations are specific to West Bengal / India

class DiseaseInfo {
  final String diseaseKey;
  final Map<String, String> displayName;   // lang → name
  final Map<String, String> symptoms;
  final Map<String, String> cause;
  final Map<String, String> treatment;
  final Map<String, String> prevention;
  final String causeType; // fungal / bacterial / viral / none
  final String severity;  // low / medium / high
  final String cropType;  // rice / wheat / corn / potato
  final bool isHealthy;

  const DiseaseInfo({
    required this.diseaseKey,
    required this.displayName,
    required this.symptoms,
    required this.cause,
    required this.treatment,
    required this.prevention,
    required this.causeType,
    required this.severity,
    required this.cropType,
    this.isHealthy = false,
  });
}

class DiseaseDatabase {
  static const Map<String, DiseaseInfo> _db = {

    // ─────────────────────────────── RICE ──────────────────────────────────

    'Healthy_Rice': DiseaseInfo(
      diseaseKey: 'Healthy_Rice',
      cropType: 'rice',
      causeType: 'none',
      severity: 'none',
      isHealthy: true,
      displayName: {
        'en': 'Healthy Rice',
        'bn': 'সুস্থ ধান',
        'hi': 'स्वस्थ धान',
      },
      symptoms: {
        'en': 'No disease symptoms. The plant looks healthy with vibrant green leaves.',
        'bn': 'কোনো রোগের লক্ষণ নেই। গাছটি সুস্থ এবং পাতা উজ্জ্বল সবুজ।',
        'hi': 'कोई रोग लक्षण नहीं। पौधा स्वस्थ है और पत्तियां चमकदार हरी हैं।',
      },
      cause: {
        'en': 'No disease detected.',
        'bn': 'কোনো রোগ নেই।',
        'hi': 'कोई रोग नहीं।',
      },
      treatment: {
        'en': 'Continue regular care. Maintain proper irrigation and balanced fertilisation.',
        'bn': 'নিয়মিত যত্ন অব্যাহত রাখুন। সঠিক সেচ ও সুষম সার ব্যবস্থাপনা করুন।',
        'hi': 'नियमित देखभाल जारी रखें। उचित सिंचाई और संतुलित उर्वरक प्रबंधन करें।',
      },
      prevention: {
        'en': 'Monitor regularly for early signs of disease.',
        'bn': 'নিয়মিত পর্যবেক্ষণ করুন।',
        'hi': 'नियमित निगरानी करें।',
      },
    ),

    'Rice_Brown_Spot': DiseaseInfo(
      diseaseKey: 'Rice_Brown_Spot',
      cropType: 'rice',
      causeType: 'fungal',
      severity: 'high',
      displayName: {
        'en': 'Rice Brown Spot',
        'bn': 'ধানের বাদামী দাগ রোগ',
        'hi': 'धान का भूरा धब्बा रोग',
      },
      symptoms: {
        'en': 'Oval to circular brown spots on leaves and grains. Spots have grey or whitish centres with dark brown margins. Severely infected leaves turn yellow.',
        'bn': 'পাতা ও দানায় ডিম্বাকৃতি থেকে গোলাকার বাদামী দাগ। দাগের কেন্দ্র ধূসর বা সাদাটে এবং কিনারা গাঢ় বাদামী। গুরুতর সংক্রমণে পাতা হলুদ হয়।',
        'hi': 'पत्तियों और दानों पर अंडाकार से गोल भूरे धब्बे। धब्बे के केंद्र में राख जैसा रंग और गहरे भूरे किनारे। गंभीर संक्रमण में पत्तियां पीली हो जाती हैं।',
      },
      cause: {
        'en': 'Fungal disease caused by Bipolaris oryzae. Spreads through infected seeds and favours warm, humid conditions. Common in soils with potassium/silicon deficiency.',
        'bn': 'Bipolaris oryzae ছত্রাকের কারণে ঘটে। আক্রান্ত বীজ থেকে ছড়ায়। উষ্ণ ও আর্দ্র পরিবেশে বেশি হয়। পটাশিয়াম/সিলিকন অভাবে বেশি দেখা যায়।',
        'hi': 'Bipolaris oryzae फफूंद से होती है। संक्रमित बीजों से फैलती है। गर्म, नम मौसम में अधिक होती है। पोटाश/सिलिकॉन की कमी वाली मिट्टी में अधिक।',
      },
      treatment: {
        'en': '1. Spray Mancozeb 75WP @ 2.5 g/L or Tricyclazole 75WP @ 0.6 g/L.\n2. Apply potassium fertiliser (MOP 60 kg/ha).\n3. Remove and burn heavily infected plants.\n4. Use certified disease-free seeds next season.',
        'bn': '১. ম্যানকোজেব ৭৫WP @ ২.৫ গ্রা/লিটার বা ট্রাইসাইক্লাজোল ৭৫WP @ ০.৬ গ্রা/লিটার স্প্রে করুন।\n২. পটাশ সার (MOP ৬০ কেজি/হেক্টর) প্রয়োগ করুন।\n৩. গুরুতর আক্রান্ত গাছ তুলে পুড়িয়ে ফেলুন।\n৪. পরের মৌসুমে রোগমুক্ত সার্টিফাইড বীজ ব্যবহার করুন।',
        'hi': '1. मेन्कोजेब 75WP @ 2.5 ग्राम/लीटर या ट्राइसाइक्लाजोल 75WP @ 0.6 ग्राम/लीटर छिड़कें।\n2. पोटाश उर्वरक (MOP 60 kg/ha) डालें।\n3. गंभीर रूप से प्रभावित पौधों को जलाएं।\n4. अगले सीजन में रोगमुक्त प्रमाणित बीज उपयोग करें।',
      },
      prevention: {
        'en': 'Use resistant varieties like Swarna Sub1. Treat seeds with Carbendazim. Avoid excessive nitrogen.',
        'bn': 'স্বর্ণা সাব১ এর মতো প্রতিরোধী জাত ব্যবহার করুন। কার্বেন্ডাজিম দিয়ে বীজ শোধন করুন।',
        'hi': 'स्वर्णा सब1 जैसी प्रतिरोधी किस्में उपयोग करें। कार्बेंडाजिम से बीज उपचार करें।',
      },
    ),

    'Rice_Leaf_Blast': DiseaseInfo(
      diseaseKey: 'Rice_Leaf_Blast',
      cropType: 'rice',
      causeType: 'fungal',
      severity: 'high',
      displayName: {
        'en': 'Rice Leaf Blast',
        'bn': 'ধানের পাতা ব্লাস্ট রোগ',
        'hi': 'धान का पत्ती ब्लास्ट रोग',
      },
      symptoms: {
        'en': 'Diamond/spindle-shaped lesions with grey-white centres and brown borders. Lesions may merge causing large portions of leaves to die.',
        'bn': 'হীরা/তর্কুর মতো আকৃতির ক্ষত, কেন্দ্র ধূসর-সাদা ও কিনারা বাদামী। ক্ষত একত্রিত হয়ে পাতার বড় অংশ মরে যায়।',
        'hi': 'हीरे/धुरी के आकार के घाव, केंद्र सफेद-राख और किनारे भूरे। घाव मिलकर पत्ती को बड़े हिस्से में नष्ट कर देते हैं।',
      },
      cause: {
        'en': 'Fungal disease caused by Magnaporthe oryzae. Airborne spores spread in cool, humid weather. One of the most destructive rice diseases in Bengal.',
        'bn': 'Magnaporthe oryzae ছত্রাক। বায়ুবাহিত স্পোর ঠাণ্ডা, আর্দ্র আবহাওয়ায় ছড়ায়। বাংলার সবচেয়ে ক্ষতিকর ধানের রোগগুলির একটি।',
        'hi': 'Magnaporthe oryzae फफूंद। हवा से फैलने वाले बीजाणु ठंडे, नम मौसम में फैलते हैं। बंगाल में धान की सबसे विनाशकारी बीमारियों में से एक।',
      },
      treatment: {
        'en': '1. Spray Tricyclazole 75WP @ 0.6 g/L at first sign.\n2. Alternatively use Isoprothiolane 40EC @ 1.5 mL/L.\n3. Repeat spray after 10–14 days if needed.\n4. Apply silicon (silica gel) to strengthen plant resistance.',
        'bn': '১. প্রথম লক্ষণ দেখামাত্র ট্রাইসাইক্লাজোল ৭৫WP @ ০.৬ গ্রা/লিটার স্প্রে করুন।\n২. বিকল্প হিসেবে আইসোপ্রোথিওলেন ৪০EC @ ১.৫ মিলি/লিটার ব্যবহার করুন।\n৩. প্রয়োজনে ১০-১৪ দিন পর পুনরায় স্প্রে করুন।\n৪. সিলিকন (সিলিকা জেল) প্রয়োগ করুন।',
        'hi': '1. पहले लक्षण दिखते ही ट्राइसाइक्लाजोल 75WP @ 0.6 ग्राम/लीटर छिड़कें।\n2. विकल्प के रूप में आइसोप्रोथियोलेन 40EC @ 1.5 mL/लीटर उपयोग करें।\n3. जरूरत हो तो 10-14 दिन बाद दोबारा छिड़कें।\n4. सिलिकॉन (सिलिका जेल) डालें।',
      },
      prevention: {
        'en': 'Use blast-resistant varieties (IR64, Lalat, Naveen). Avoid excess nitrogen. Balanced water management.',
        'bn': 'ব্লাস্ট-প্রতিরোধী জাত (IR64, লালাত, নবীন) ব্যবহার করুন। অতিরিক্ত নাইট্রোজেন এড়িয়ে চলুন।',
        'hi': 'ब्लास्ट-प्रतिरोधी किस्में (IR64, लालत, नवीन) उपयोग करें। अधिक नाइट्रोजन न डालें।',
      },
    ),

    // ─────────────────────────────── WHEAT ─────────────────────────────────

    'Healthy_Wheat': DiseaseInfo(
      diseaseKey: 'Healthy_Wheat',
      cropType: 'wheat',
      causeType: 'none',
      severity: 'none',
      isHealthy: true,
      displayName: {
        'en': 'Healthy Wheat',
        'bn': 'সুস্থ গম',
        'hi': 'स्वस्थ गेहूं',
      },
      symptoms: {
        'en': 'No disease symptoms. Healthy green leaves and developing heads.',
        'bn': 'কোনো রোগের লক্ষণ নেই। সুস্থ সবুজ পাতা ও শীষ।',
        'hi': 'कोई रोग लक्षण नहीं। स्वस्थ हरी पत्तियां और बालियां।',
      },
      cause: {
        'en': 'No disease detected.',
        'bn': 'কোনো রোগ নেই।',
        'hi': 'कोई रोग नहीं।',
      },
      treatment: {
        'en': 'Continue regular care. Ensure timely irrigation especially at crown root initiation and jointing stages.',
        'bn': 'নিয়মিত যত্ন অব্যাহত রাখুন। বিশেষত গোড়া মূল ও জয়েন্টিং পর্যায়ে সেচ নিশ্চিত করুন।',
        'hi': 'नियमित देखभाल जारी रखें। खासकर क्राउन रूट और ज्वाइंटिंग स्टेज पर सिंचाई सुनिश्चित करें।',
      },
      prevention: {
        'en': 'Regular monitoring for disease and pest incidence.',
        'bn': 'রোগ ও পোকামাকড়ের জন্য নিয়মিত পর্যবেক্ষণ।',
        'hi': 'रोग और कीट के लिए नियमित निगरानी।',
      },
    ),

    'Wheat_Brown_Rust': DiseaseInfo(
      diseaseKey: 'Wheat_Brown_Rust',
      cropType: 'wheat',
      causeType: 'fungal',
      severity: 'high',
      displayName: {
        'en': 'Wheat Brown Rust',
        'bn': 'গমের বাদামী মরিচা রোগ',
        'hi': 'गेहूं का भूरा रतुआ रोग',
      },
      symptoms: {
        'en': 'Small, round to oval, orange-brown pustules on upper leaf surface. Pustules are scattered randomly. Severe infection causes premature leaf drying.',
        'bn': 'পাতার উপরের পৃষ্ঠে ছোট, গোল থেকে ডিম্বাকৃতি কমলা-বাদামী পুস্টুল। তীব্র সংক্রমণে পাতা আগাম শুকিয়ে যায়।',
        'hi': 'पत्ती की ऊपरी सतह पर छोटे, गोल से अंडाकार नारंगी-भूरे पुस्टुल। गंभीर संक्रमण में पत्तियां समय से पहले सूख जाती हैं।',
      },
      cause: {
        'en': 'Fungal disease caused by Puccinia recondita. Wind-dispersed spores. Favours temperatures of 15–22°C with high humidity. Major threat to wheat in India.',
        'bn': 'Puccinia recondita ছত্রাক। বায়ুবাহিত স্পোর। ১৫-২২°C তাপমাত্রা ও উচ্চ আর্দ্রতায় বৃদ্ধি পায়। ভারতে গমের প্রধান শত্রু।',
        'hi': 'Puccinia recondita फफूंद। हवा से फैलते बीजाणु। 15-22°C तापमान और उच्च आर्द्रता में पनपती है। भारत में गेहूं की प्रमुख बीमारी।',
      },
      treatment: {
        'en': '1. Spray Propiconazole 25EC @ 1 mL/L at first sign.\n2. Tebuconazole 25.9EC @ 1 mL/L also effective.\n3. Repeat after 15 days if disease progresses.\n4. Ensure balanced nitrogen — avoid excess.',
        'bn': '১. প্রথম লক্ষণে প্রোপিকোনাজোল ২৫EC @ ১ মিলি/লিটার স্প্রে করুন।\n২. টেবুকোনাজোল ২৫.৯EC @ ১ মিলি/লিটারও কার্যকর।\n৩. রোগ বাড়লে ১৫ দিন পর পুনরায় স্প্রে করুন।\n৪. অতিরিক্ত নাইট্রোজেন এড়িয়ে চলুন।',
        'hi': '1. पहले लक्षण पर प्रोपिकोनाजोल 25EC @ 1 mL/लीटर छिड़कें।\n2. टेबुकोनाजोल 25.9EC @ 1 mL/लीटर भी प्रभावी।\n3. 15 दिन बाद दोबारा छिड़कें यदि रोग बढ़े।\n4. अधिक नाइट्रोजन न दें।',
      },
      prevention: {
        'en': 'Use rust-resistant varieties (HD2781, PBW343). Early sowing. Remove volunteer wheat plants.',
        'bn': 'মরিচা-প্রতিরোধী জাত (HD2781, PBW343) ব্যবহার করুন। সময়মতো বপন।',
        'hi': 'रोगरोधी किस्में (HD2781, PBW343) उपयोग करें। समय से बुवाई करें।',
      },
    ),

    // ─────────────────────────────── CORN ──────────────────────────────────

    'Healthy_Corn': DiseaseInfo(
      diseaseKey: 'Healthy_Corn',
      cropType: 'corn',
      causeType: 'none',
      severity: 'none',
      isHealthy: true,
      displayName: {
        'en': 'Healthy Corn',
        'bn': 'সুস্থ ভুট্টা',
        'hi': 'स्वस्थ मक्का',
      },
      symptoms: {
        'en': 'No disease symptoms. Healthy, vibrant green corn plant.',
        'bn': 'কোনো রোগের লক্ষণ নেই। সুস্থ উজ্জ্বল সবুজ ভুট্টা গাছ।',
        'hi': 'कोई रोग लक्षण नहीं। स्वस्थ, हरा-भरा मक्का पौधा।',
      },
      cause: {
        'en': 'No disease detected.',
        'bn': 'কোনো রোগ নেই।',
        'hi': 'कोई रोग नहीं।',
      },
      treatment: {
        'en': 'Continue regular care. Monitor for fall armyworm.',
        'bn': 'নিয়মিত যত্ন করুন। ফল আর্মিওয়ার্মের জন্য পর্যবেক্ষণ করুন।',
        'hi': 'नियमित देखभाल जारी रखें। फॉल आर्मीवर्म की निगरानी करें।',
      },
      prevention: {
        'en': 'Regular monitoring for pests and diseases.',
        'bn': 'পোকামাকড় ও রোগের জন্য নিয়মিত পর্যবেক্ষণ।',
        'hi': 'कीट और रोग के लिए नियमित निगरानी।',
      },
    ),

    'Corn_Common_Rust': DiseaseInfo(
      diseaseKey: 'Corn_Common_Rust',
      cropType: 'corn',
      causeType: 'fungal',
      severity: 'medium',
      displayName: {
        'en': 'Corn Common Rust',
        'bn': 'ভুট্টার সাধারণ মরিচা রোগ',
        'hi': 'मक्का का सामान्य रतुआ रोग',
      },
      symptoms: {
        'en': 'Elongated, powdery, brick-red to dark brown pustules on both leaf surfaces. Pustules appear on both sides of the leaf, distinguishing it from other rusts.',
        'bn': 'উভয় পাতার পৃষ্ঠে লম্বাটে, গুঁড়া গুঁড়া, ইটের লাল থেকে গাঢ় বাদামী পুস্টুল।',
        'hi': 'दोनों पत्ती सतहों पर लम्बे, चूर्णी, ईंट-लाल से गहरे भूरे पुस्टुल।',
      },
      cause: {
        'en': 'Fungal disease caused by Puccinia sorghi. Favours cool temperatures (16–23°C) and high humidity. Wind-dispersed spores.',
        'bn': 'Puccinia sorghi ছত্রাক। ঠাণ্ডা তাপমাত্রা (১৬-২৩°C) ও উচ্চ আর্দ্রতায় বেশি হয়।',
        'hi': 'Puccinia sorghi फफूंद। ठंडा तापमान (16-23°C) और उच्च आर्द्रता में अधिक।',
      },
      treatment: {
        'en': '1. Spray Mancozeb 75WP @ 2.5 g/L or Zineb 75WP @ 2 g/L.\n2. Propiconazole 25EC @ 1 mL/L for severe infections.\n3. Spray at 10–14 day intervals.',
        'bn': '১. ম্যানকোজেব ৭৫WP @ ২.৫ গ্রা/লিটার বা জিনেব ৭৫WP @ ২ গ্রা/লিটার স্প্রে করুন।\n২. তীব্র সংক্রমণে প্রোপিকোনাজোল ২৫EC @ ১ মিলি/লিটার।\n৩. ১০-১৪ দিন অন্তর স্প্রে করুন।',
        'hi': '1. मेन्कोजेब 75WP @ 2.5 ग्राम/लीटर या जिनेब 75WP @ 2 ग्राम/लीटर छिड़कें।\n2. गंभीर संक्रमण में प्रोपिकोनाजोल 25EC @ 1 mL/लीटर।\n3. 10-14 दिन के अंतराल पर छिड़कें।',
      },
      prevention: {
        'en': 'Use resistant hybrid varieties. Plant early.',
        'bn': 'প্রতিরোধী হাইব্রিড জাত ব্যবহার করুন। আগাম রোপণ করুন।',
        'hi': 'प्रतिरोधी हाइब्रिड किस्में उपयोग करें। जल्दी बुवाई करें।',
      },
    ),

    'Corn_Gray_Leaf_Spot': DiseaseInfo(
      diseaseKey: 'Corn_Gray_Leaf_Spot',
      cropType: 'corn',
      causeType: 'fungal',
      severity: 'medium',
      displayName: {
        'en': 'Corn Gray Leaf Spot',
        'bn': 'ভুট্টার ধূসর পাতার দাগ রোগ',
        'hi': 'मक्का का धूसर पत्ती धब्बा रोग',
      },
      symptoms: {
        'en': 'Rectangular, tan to grey lesions with parallel edges running along leaf veins. Lesions may have yellow halos. Severely affected leaves turn completely grey.',
        'bn': 'পাতার শিরার সমান্তরালে আয়তক্ষেত্রাকার তান থেকে ধূসর ক্ষত। তীব্র আক্রমণে পাতা সম্পূর্ণ ধূসর হয়।',
        'hi': 'पत्ती नसों के समानांतर आयताकार, तन से ग्रे घाव। गंभीर प्रकोप में पूरी पत्ती ग्रे हो जाती है।',
      },
      cause: {
        'en': 'Fungal disease caused by Cercospora zeae-maydis. Favoured by warm, humid conditions and poor air circulation.',
        'bn': 'Cercospora zeae-maydis ছত্রাক। উষ্ণ, আর্দ্র পরিবেশে বাড়ে।',
        'hi': 'Cercospora zeae-maydis फफूंद। गर्म, नम स्थितियों में बढ़ती है।',
      },
      treatment: {
        'en': '1. Spray Azoxystrobin 18.2% + Difenoconazole 11.4% SC @ 1 mL/L.\n2. Chlorothalonil 75WP @ 2 g/L also effective.\n3. Improve field drainage.',
        'bn': '১. অ্যাজোক্সিস্ট্রোবিন ১৮.২% + ডিফেনোকোনাজোল ১১.৪% SC @ ১ মিলি/লিটার স্প্রে করুন।\n২. ক্লোরোথালোনিল ৭৫WP @ ২ গ্রা/লিটারও কার্যকর।',
        'hi': '1. एज़ोक्सीस्ट्रोबिन 18.2% + डाइफेनोकोनाजोल 11.4% SC @ 1 mL/लीटर छिड़कें।\n2. क्लोरोथैलोनिल 75WP @ 2 ग्राम/लीटर भी प्रभावी।',
      },
      prevention: {
        'en': 'Crop rotation. Tillage to bury infected residue. Use tolerant hybrids.',
        'bn': 'শস্য আবর্তন। সংক্রমিত অবশিষ্ট কাটায় পুঁতে দিন। সহনশীল হাইব্রিড ব্যবহার করুন।',
        'hi': 'फसल चक्र। संक्रमित अवशेष को जोतकर दबाएं। सहनशील हाइब्रिड उपयोग करें।',
      },
    ),

    // ─────────────────────────────── POTATO ────────────────────────────────

    'Healthy_Potato': DiseaseInfo(
      diseaseKey: 'Healthy_Potato',
      cropType: 'potato',
      causeType: 'none',
      severity: 'none',
      isHealthy: true,
      displayName: {
        'en': 'Healthy Potato',
        'bn': 'সুস্থ আলু',
        'hi': 'स्वस्थ आलू',
      },
      symptoms: {
        'en': 'No disease symptoms. Healthy green foliage.',
        'bn': 'কোনো রোগের লক্ষণ নেই। সুস্থ সবুজ পাতা।',
        'hi': 'कोई रोग लक्षण नहीं। स्वस्थ हरी पत्तियां।',
      },
      cause: {
        'en': 'No disease detected.',
        'bn': 'কোনো রোগ নেই।',
        'hi': 'कोई रोग नहीं।',
      },
      treatment: {
        'en': 'Continue regular care. Monitor for late blight especially in winter.',
        'bn': 'নিয়মিত যত্ন করুন। বিশেষত শীতকালে লেট ব্লাইটের জন্য পর্যবেক্ষণ করুন।',
        'hi': 'नियमित देखभाल जारी रखें। खासकर सर्दियों में लेट ब्लाइट की निगरानी करें।',
      },
      prevention: {
        'en': 'Regular scouting for early and late blight.',
        'bn': 'আর্লি ও লেট ব্লাইটের জন্য নিয়মিত পর্যবেক্ষণ।',
        'hi': 'अर्ली और लेट ब्लाइट के लिए नियमित स्काउटिंग।',
      },
    ),

    'Potato_Early_Blight': DiseaseInfo(
      diseaseKey: 'Potato_Early_Blight',
      cropType: 'potato',
      causeType: 'fungal',
      severity: 'medium',
      displayName: {
        'en': 'Potato Early Blight',
        'bn': 'আলুর আর্লি ব্লাইট রোগ',
        'hi': 'आलू का अगेती झुलसा रोग',
      },
      symptoms: {
        'en': 'Dark brown to black spots with concentric rings (target board pattern). Yellow halo around spots. Begins on older lower leaves, progresses upward.',
        'bn': 'গাঢ় বাদামী থেকে কালো দাগ, কেন্দ্রীভূত বলয় (টার্গেট বোর্ড প্যাটার্ন)। দাগের চারদিকে হলুদ হ্যালো। পুরনো নিচের পাতা থেকে শুরু হয়।',
        'hi': 'गहरे भूरे से काले धब्बे, केन्द्रित वलय (निशाना बोर्ड पैटर्न)। धब्बों के चारों तरफ पीला हैलो। पुरानी निचली पत्तियों से शुरू होती है।',
      },
      cause: {
        'en': 'Fungal disease caused by Alternaria solani. Favours warm (24–29°C), humid weather. More severe on stressed, nutrient-deficient plants.',
        'bn': 'Alternaria solani ছত্রাক। উষ্ণ (২৪-২৯°C), আর্দ্র আবহাওয়ায় বেশি হয়। পুষ্টিহীন গাছে বেশি তীব্র।',
        'hi': 'Alternaria solani फफूंद। गर्म (24-29°C), नम मौसम में अधिक। पोषक तत्वों की कमी वाले पौधों में अधिक गंभीर।',
      },
      treatment: {
        'en': '1. Spray Mancozeb 75WP @ 2.5 g/L every 7–10 days.\n2. Chlorothalonil 75WP @ 2 g/L is also effective.\n3. Remove infected leaves and destroy.\n4. Ensure balanced NPK fertilisation.',
        'bn': '১. প্রতি ৭-১০ দিনে ম্যানকোজেব ৭৫WP @ ২.৫ গ্রা/লিটার স্প্রে করুন।\n২. ক্লোরোথালোনিল ৭৫WP @ ২ গ্রা/লিটারও কার্যকর।\n৩. আক্রান্ত পাতা তুলে নষ্ট করুন।\n৪. সুষম NPK সার নিশ্চিত করুন।',
        'hi': '1. हर 7-10 दिन में मेन्कोजेब 75WP @ 2.5 ग्राम/लीटर छिड़कें।\n2. क्लोरोथैलोनिल 75WP @ 2 ग्राम/लीटर भी प्रभावी।\n3. संक्रमित पत्तियां हटाकर नष्ट करें।\n4. संतुलित NPK उर्वरक सुनिश्चित करें।',
      },
      prevention: {
        'en': 'Use certified seed tubers. Crop rotation with non-solanaceous crops. Adequate plant spacing for air circulation.',
        'bn': 'সার্টিফাইড বীজ আলু ব্যবহার করুন। সোলানাসিয়াস ছাড়া অন্য ফসলের সাথে শস্য আবর্তন।',
        'hi': 'प्रमाणित बीज कंद उपयोग करें। सोलानेसियस फसलों के अलावा फसल चक्र करें।',
      },
    ),

    'Potato_Late_Blight': DiseaseInfo(
      diseaseKey: 'Potato_Late_Blight',
      cropType: 'potato',
      causeType: 'fungal',
      severity: 'high',
      displayName: {
        'en': 'Potato Late Blight',
        'bn': 'আলুর লেট ব্লাইট রোগ',
        'hi': 'आलू का पछेती झुलसा रोग',
      },
      symptoms: {
        'en': 'Water-soaked, pale green to dark brown/black lesions on leaves. White fluffy mould on underside in humid conditions. Rapid spread causing total foliage death. Tubers show brown rot.',
        'bn': 'পাতায় জলভেজা, ফ্যাকাসে সবুজ থেকে গাঢ় বাদামী/কালো ক্ষত। আর্দ্রতায় পাতার নিচে সাদা তুলার মতো ছত্রাক। দ্রুত ছড়িয়ে সমস্ত পাতা মেরে ফেলে। কন্দে বাদামী পচন।',
        'hi': 'पत्तियों पर पानी से भीगे, हल्के हरे से गहरे भूरे/काले घाव। नम स्थितियों में पत्ती के नीचे सफेद रोएंदार फफूंद। तेजी से फैलकर सारी पत्तियां नष्ट। कंद में भूरा सड़न।',
      },
      cause: {
        'en': 'Caused by Phytophthora infestans (oomycete). Spreads rapidly in cool (10–20°C), moist conditions. The same pathogen that caused the Irish Famine. Critical threat in Bengal winters.',
        'bn': 'Phytophthora infestans (ওমাইসিট) এর কারণে হয়। ঠাণ্ডা (১০-২০°C), আর্দ্র পরিবেশে দ্রুত ছড়ায়। বাংলার শীতকালে গুরুতর হুমকি।',
        'hi': 'Phytophthora infestans (ओमाइसेट) से होती है। ठंडे (10-20°C), नम मौसम में तेजी से फैलती है। बंगाल की सर्दियों में गंभीर खतरा।',
      },
      treatment: {
        'en': '1. Spray Metalaxyl 8% + Mancozeb 64% WP @ 2.5 g/L immediately.\n2. Cymoxanil 8% + Mancozeb 64% WP @ 3 g/L also very effective.\n3. Spray every 5–7 days during conducive weather.\n4. Remove and destroy infected plants to prevent spread.',
        'bn': '১. সঙ্গে সঙ্গে মেটালাক্সিল ৮% + ম্যানকোজেব ৬৪% WP @ ২.৫ গ্রা/লিটার স্প্রে করুন।\n২. সাইমোক্সানিল ৮% + ম্যানকোজেব ৬৪% WP @ ৩ গ্রা/লিটারও খুব কার্যকর।\n৩. অনুকূল আবহাওয়ায় প্রতি ৫-৭ দিনে স্প্রে করুন।\n৪. আক্রান্ত গাছ তুলে নষ্ট করুন।',
        'hi': '1. तुरंत मेटालेक्सिल 8% + मेन्कोजेब 64% WP @ 2.5 ग्राम/लीटर छिड़कें।\n2. साइमोक्सेनिल 8% + मेन्कोजेब 64% WP @ 3 ग्राम/लीटर बहुत प्रभावी।\n3. अनुकूल मौसम में 5-7 दिन पर छिड़कें।\n4. संक्रमित पौधे उखाड़कर नष्ट करें।',
      },
      prevention: {
        'en': 'Use resistant varieties (Kufri Jyoti, Kufri Bahar). Preventive spraying before monsoon. Remove volunteer plants. Proper storage of seed tubers.',
        'bn': 'প্রতিরোধী জাত (কুফরি জ্যোতি, কুফরি বাহার) ব্যবহার করুন। বর্ষার আগে প্রতিরোধমূলক স্প্রে।',
        'hi': 'प्रतिरोधी किस्में (कुफरी ज्योति, कुफरी बहार) उपयोग करें। मानसून से पहले निवारक छिड़काव।',
      },
    ),
  };

  /// Returns disease info for a given label string.
  /// Tries exact match first, then fuzzy match.
  static DiseaseInfo getInfo(String label) {
    // Try exact
    if (_db.containsKey(label)) return _db[label]!;

    // Normalise: replace spaces with underscore, strip leading/trailing spaces
    final normalised = label.trim().replaceAll(' ', '_');
    if (_db.containsKey(normalised)) return _db[normalised]!;

    // Fuzzy: find closest key by substring
    for (final key in _db.keys) {
      if (key.toLowerCase().contains(normalised.toLowerCase()) ||
          normalised.toLowerCase().contains(key.toLowerCase())) {
        return _db[key]!;
      }
    }

    // Fallback: create generic healthy info
    return DiseaseInfo(
      diseaseKey: label,
      cropType: 'unknown',
      causeType: 'unknown',
      severity: 'unknown',
      displayName: {'en': label, 'bn': label, 'hi': label},
      symptoms: {
        'en': 'No specific information available.',
        'bn': 'কোনো নির্দিষ্ট তথ্য নেই।',
        'hi': 'कोई विशिष्ट जानकारी उपलब्ध नहीं।',
      },
      cause: {'en': 'Unknown', 'bn': 'অজানা', 'hi': 'अज्ञात'},
      treatment: {
        'en': 'Please consult your local agricultural extension officer.',
        'bn': 'আপনার স্থানীয় কৃষি সম্প্রসারণ কর্মকর্তার সাথে যোগাযোগ করুন।',
        'hi': 'अपने स्थानीय कृषि विस्तार अधिकारी से संपर्क करें।',
      },
      prevention: {'en': 'Monitor regularly.', 'bn': 'নিয়মিত পর্যবেক্ষণ।', 'hi': 'नियमित निगरानी।'},
    );
  }

  static List<DiseaseInfo> get allDiseases => _db.values.toList();
}
