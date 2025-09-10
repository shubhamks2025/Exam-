# Exam Goal Demo App (Firebase)

## Setup
1. Firebase Console में project बनाएं और `google-services.json` file को `android/app/` folder में डालें।
2. Repo GitHub पर upload करें।
3. Codemagic.io से connect करें।
4. APK/AAB build करें।
5. APK testing के लिए, AAB Play Store upload के लिए।

## Firestore Structure Example
/tests/{testId}
  name: "Physics Mock Test"
  duration: 60
  /questions/{qId}
    text: "What is 2+2?"
    options: ["1","2","3","4"]
    correctIndex: 3
