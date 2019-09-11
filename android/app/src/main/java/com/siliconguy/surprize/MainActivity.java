package com.siliconguy.surprize;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import java.net.URI;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  static String CHANNEL_NAME = "com.siliconguy.surprize/facebookShare";
  static String METHOD_FACEBOOK_SHARE_NAME = "shareAppOnFacebook";
  static String METHOD_FACEBOOK_SHARE_WITH_VALUE_NAME = "shareAppOnFacebookWithScore";
  static String ARGUMENT_MY_SCORE = "myScore";

  CallbackManager _callBackManager;
  ShareDialog _shareDialog;

  MethodChannel.Result _methodChannelResult;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    _callBackManager =  CallbackManager.Factory.create();
    new MethodChannel(getFlutterView(), CHANNEL_NAME).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        _methodChannelResult = result;

        if(methodCall.method.equals(METHOD_FACEBOOK_SHARE_NAME)){
          shareToFacebook();
        }
        if(methodCall.method.equals(METHOD_FACEBOOK_SHARE_WITH_VALUE_NAME)){
          String score = methodCall.argument(ARGUMENT_MY_SCORE);
          _setQuote  = "I just scored " + score;
          shareToFacebook();
        }
        else{
          result.notImplemented();
        }
      }
    });
  }


  Uri _uri = Uri.parse("https://blyaank.com");
  String _setQuote = "App Sharing";

  void shareToFacebook(){
    _shareDialog = new ShareDialog(this);

    ShareLinkContent shareLinkContent = new ShareLinkContent.Builder()
            .setContentUrl(_uri)
            .setQuote(_setQuote).build();

    if(_shareDialog.canShow(shareLinkContent)){
      _shareDialog.show(shareLinkContent);
      shareDialogResult();
    }

  }

  void shareDialogResult(){
    _shareDialog.registerCallback(_callBackManager, new FacebookCallback<Sharer.Result>() {
      @Override
      public void onSuccess(Sharer.Result result) {
        _methodChannelResult.success("APP_SHARED");
      }

      @Override
      public void onCancel() {
        _methodChannelResult.success("APP_SHARE_CANCELED");
      }

      @Override
      public void onError(FacebookException error) {
        _methodChannelResult.success("APP_SHARE_CANCELED");
      }
    });
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    try {
      _callBackManager.onActivityResult(requestCode, resultCode, data);
    }
    catch (Exception exception){

    }
  }
}
