import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UrlHandler {
  static const String _apiEndpointKey = 'api_endpoint';
  static const String _defaultApiEndpoint = 'https://chmeni.pro/plcy';
  static const String _savedUrlKey = 'saved_redirect_url';
  static const String _isFirstOpenKey = 'is_first_open';
  
  /// Initialize and check first open status
  static Future<void> initialize() async {
    print('🔵 UrlHandler.initialize() - Starting initialization...');
    
    final prefs = await SharedPreferences.getInstance();
    bool isFirstOpen = prefs.getBool(_isFirstOpenKey) ?? true;
    
    print('🔵 Is First Open: $isFirstOpen');
    
    if (isFirstOpen) {
      print('🟢 FIRST OPEN DETECTED - Will fetch from API');
      
      // Mark as not first open anymore
      await prefs.setBool(_isFirstOpenKey, false);
      print('🟢 Marked app as "not first open" for future launches');
      
      // Fetch URL from API on first open
      String apiEndpoint = await getApiEndpoint();
      print('🟡 Calling API: $apiEndpoint');
      String? apiUrl = await fetchUrlFromApi();
      
      if (apiUrl != null) {
        // Save the URL for future launches
        await prefs.setString(_savedUrlKey, apiUrl);
        print('✅ SUCCESS: URL saved for future launches: $apiUrl');
      } else {
        print('⚠️ WARNING: No URL received from API on first open');
        print('⚠️ App will continue normally without redirect functionality');
      }
    } else {
      print('🔵 NOT FIRST OPEN - Checking for saved URL...');
      String? savedUrl = prefs.getString(_savedUrlKey);
      if (savedUrl != null) {
        print('✅ Found saved URL: $savedUrl');
      } else {
        print('ℹ️ No saved URL found - will go to HomePage');
      }
    }
    
    print('🔵 UrlHandler.initialize() - Completed');
  }
  
  /// Fetch URL from API
  static Future<String?> fetchUrlFromApi() async {
    print('📡 fetchUrlFromApi() - Starting API call...');
    String apiEndpoint = await getApiEndpoint();
    print('📡 API Endpoint: $apiEndpoint');
    
    try {
      print('📡 Making HTTP GET request...');
      final response = await http.get(
        Uri.parse(apiEndpoint),
      ).timeout(const Duration(seconds: 10));
      
      print('📡 Response Status Code: ${response.statusCode}');
      print('📡 Response Headers: ${response.headers}');
      print('📡 Response Body (raw): "${response.body}"');
      print('📡 Response Body Length: ${response.body.length} characters');
      
      if (response.statusCode == 200) {
        // The API returns a plain text URL string
        final body = response.body.trim();
        print('📡 Trimmed Response Body: "$body"');
        
        // Validate that it's a valid URL
        if (body.isNotEmpty && 
            (body.startsWith('http://') || body.startsWith('https://'))) {
          print('✅ Valid URL detected: $body');
          return body;
        } else {
          print('❌ Invalid URL format. Body: "$body"');
          print('❌ Starts with http://? ${body.startsWith('http://')}');
          print('❌ Starts with https://? ${body.startsWith('https://')}');
          print('❌ Is empty? ${body.isEmpty}');
        }
      } else {
        print('❌ Non-200 status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching URL from API: $e');
      print('❌ Error type: ${e.runtimeType}');
    }
    
    print('📡 fetchUrlFromApi() - Returning null');
    return null;
  }
  
  /// Check if we should redirect (only on second launch and beyond if URL exists)
  static Future<bool> shouldRedirect() async {
    print('🔍 shouldRedirect() - Checking redirect conditions...');
    
    final prefs = await SharedPreferences.getInstance();
    
    // Check if we have a saved URL (first open check already done in initialize)
    String? savedUrl = prefs.getString(_savedUrlKey);
    print('🔍 Saved URL: ${savedUrl ?? "None"}');
    
    bool shouldRedirect = savedUrl != null && savedUrl.isNotEmpty;
    print('🔍 Decision: ${shouldRedirect ? "REDIRECT TO URL" : "NO REDIRECT (No URL)"}');
    
    return shouldRedirect;
  }
  
  /// Get the saved redirect URL
  static Future<String?> getRedirectUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedUrlKey);
  }
  
  /// Reset everything to initial state
  static Future<void> resetToFirstOpen() async {
    print('🔄 resetToFirstOpen() - Resetting app to first open state...');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedUrlKey);
    await prefs.setBool(_isFirstOpenKey, true);
    
    print('🔄 Cleared saved URL');
    print('🔄 Set first open flag to true');
    print('🔄 App will fetch from API on next launch');
  }
  
  /// Check if this is first open
  static Future<bool> isFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstOpenKey) ?? true;
  }
  
  /// Get saved URL without checking conditions
  static Future<String?> getSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedUrlKey);
  }
  
  /// Manually set a URL (for testing)
  static Future<void> setSavedUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedUrlKey, url);
    await prefs.setBool(_isFirstOpenKey, false);
  }
  
  /// Get API endpoint (configurable)
  static Future<String> getApiEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiEndpointKey) ?? _defaultApiEndpoint;
  }
  
  /// Set API endpoint
  static Future<void> setApiEndpoint(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiEndpointKey, endpoint);
    print('✅ API endpoint set: $endpoint');
  }
  
  /// Reset API endpoint to default
  static Future<void> resetApiEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiEndpointKey);
    print('✅ API endpoint reset to default: $_defaultApiEndpoint');
  }
  
  /// Set test URL (configurable) - for testing only, doesn't affect first open flag
  static Future<void> setTestUrl([String? testUrl]) async {
    testUrl ??= 'https://www.ceneo.pl/105799656?srsltid=AfmBOopeZzqDO5cnbyplENjUwJ1skxfc-Lo5f6qEWPZD8Pi8TPF93qjL';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedUrlKey, testUrl);
    // Don't modify _isFirstOpenKey here - let initialize() handle it properly
    print('✅ Test URL set: $testUrl');
  }
}