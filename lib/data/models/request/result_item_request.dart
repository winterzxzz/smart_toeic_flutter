// To parse this JSON data, do
//
//     final resultTestRequest = resultTestRequestFromJson(jsonString);

import 'dart:convert';

ResultTestRequest resultTestRequestFromJson(String str) => ResultTestRequest.fromJson(json.decode(str));

String resultTestRequestToJson(ResultTestRequest data) => json.encode(data.toJson());

class ResultTestRequest {
    Rs rs;
    List<Rsi> rsis;

    ResultTestRequest({
        required this.rs,
        required this.rsis,
    });

    factory ResultTestRequest.fromJson(Map<String, dynamic> json) => ResultTestRequest(
        rs: Rs.fromJson(json["rs"]),
        rsis: List<Rsi>.from(json["rsis"].map((x) => Rsi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "rs": rs.toJson(),
        "rsis": List<dynamic>.from(rsis.map((x) => x.toJson())),
    };
}

class Rs {
    String testId;
    int numberOfQuestions;
    int secondTime;

    Rs({
        required this.testId,
        required this.numberOfQuestions,
        required this.secondTime,
    });

    factory Rs.fromJson(Map<String, dynamic> json) => Rs(
        testId: json["testId"],
        numberOfQuestions: json["numberOfQuestions"],
        secondTime: json["secondTime"],
    );

    Map<String, dynamic> toJson() => {
        "testId": testId,
        "numberOfQuestions": numberOfQuestions,
        "secondTime": secondTime,
    };
}

class Rsi {
    String useranswer;
    String correctanswer;
    String questionNum;
    int rsiPart;

    Rsi({
        required this.useranswer,
        required this.correctanswer,
        required this.questionNum,
        required this.rsiPart,
    });

    factory Rsi.fromJson(Map<String, dynamic> json) => Rsi(
        useranswer: json["useranswer"],
        correctanswer: json["correctanswer"],
        questionNum: json["questionNum"],
        rsiPart: json["part"],
    );

    Map<String, dynamic> toJson() => {
        "useranswer": useranswer,
        "correctanswer": correctanswer,
        "questionNum": questionNum,
        "part": rsiPart,
    };
}
