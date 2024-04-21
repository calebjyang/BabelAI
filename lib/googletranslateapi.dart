import 'package:googleapis/translate/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<String> translateText(String text) async {
  // Load the JSON key file containing your GCP credentials
  var credentials = ServiceAccountCredentials.fromJson({
    "private_key_id": "ea2e05f4c2f60611fa53790358a20cd4b88f2558",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC45zb7LD60Di0o\nW/L/CVvnGTvebGvF9EWSzws18xd/KHngfElUXW6e/jSyNiP7JrpsPW1gt1BvbFSE\nQYurVRaYuHUnkTSQbva2zS3wqojQo8EdYoa6arrx9HEO8PO5Fey+0x8a2KaIPoFw\nPqjQc777X0HqS7aQuPdbAQ5mdbniU+zL6x+BS8rdN09r7KaI8V1QyqpSdepj8Kkg\ndtpd8cjIzO/mbCd7RdAK14z4DInrztyOBH7OfJnMSI7mAkP2woPvYPbyITBmd61A\n3L21kvLPct9flJz//buQLWcmNnSmFbt5urXtvm+Bqd/rr2zL3fmHvvsOZ4qbXuad\nALoTbxipAgMBAAECggEAT8oSqzuSCU/Ow8o95zkqK+TzNU2TCjaZKTtoCo1Od+RH\nB4yKdjnlSP3ITpjXWQMC0j+FqgUg1BwqsnG4bCRJHnkGsR7TUHpZw1Nx/hcQ9/ua\nE2yXV+1Do7JIcVqfyaBA662eEA8qecODRqT7Ywx3fvDBuHGYpAX1U5N2m9c0cgnq\nHX/GivHh/G39wh/ZvNaQMzEcCecQ3rO5kwdexxxlLkQRTRaDDrZ4v0eDCXr2olFt\nsuUEvk4YpKmh+nh5HFC1cOQbzyRMjEWmXzIC1Ux5lSxI39X7ANbH6Fx04ZQxpop8\neWcdeK/KnPYmoQDoO+08pfxS4Sufbd8frNSIcLHcQwKBgQDmyla7RGP29/B7mrO6\nxVkJu9jxM4zIMpiRSCpiZZDozyfF6MfBs0H79qwzJEmuXH1CghisCEX/oo0Q4g9i\nqhmNeV1CvNZ2CWtHNYb5Ihx/Isc64SYlTDBnMv2pzGITSelP/5XrBMwKmq/M9kCk\n7ygpmyRcooOpKy5so1Ik/32O8wKBgQDNGbfgLaPHVA/Y6sjiKZnrWSbdyVXC/2cE\nhnjaatUhG89zXcX/eLsxtAF5AMFG6oOqJb/le3BzWXdupNaHJpjlt9UWhFyWEXFg\n+yH4mJetzmQaUN07P8FR0a4dZzeTlFKqRecfDTwRLAB2zYRQTXNlTkN73DyWJG5l\nvn85M2f48wKBgHzza4Wz/1NE5YRmO4yRMCWe+FOOj1gMXKG7qobfaldBYM07vHrY\nrI7X/F8r9GBcXszVVro9OHiw7yMG4UGPyonX/XAWgR4i91v0VQEpQLhsgeUU5Owo\nlcQpzUBTEX5T8+eF/wrg6/+JxEh5woIJoXr1LfihXBsI7/eNbPnvAXGVAoGAUxxx\n24EDFhnlVhRGFQegnLMCwer9Osh+OWI4hOG3vfPkC67bNhv5VznHQv5gU9liQ0eK\nzHZJ6iQ99nMLj7a/TI9C5R372r/0vsTlTjSfeknhXJyaGZFLSFl8geO6rK31FZTA\nBGA7kAXRplK/pD7OXSXqyL1FO95FcitQqKBBKKsCgYBIhtNU5j83FDJpgqInh6YC\n72cPDloxlCm17fwuCltaTvXgKfYNf7Ze8U/MjHkpITdAa8moQtgmp61FKmzlJWhi\nKjhJl10T9fAzYZkXPWrAHltR0PqU1jmHFB/TYN8mHeaoDA2jTngfMt7HMZrV87Wh\n8m8NINDGQTkJFng4w2MYIw==\n-----END PRIVATE KEY-----\n",
    "client_email": "adan-jeronimo@cybernetic-day-421001.iam.gserviceaccount.com",
    "client_id": "105190656426592542428",
    "type": "service_account"
  });

  // Initialize the translation client
  var client = GoogleTranslateV3(
    await clientViaServiceAccount(
        credentials, [TranslateApi.CloudTranslationScope]),
  );

  // Translate the text
  var translation = await client.translations.translate(
    text,
    to: 'es', 
  );

  // Return the translated text
  return translation.translatedText;
}
