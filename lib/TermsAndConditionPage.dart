import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsAndConditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Terms and Condition", context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Html(
              data: html ,
            ),
          ),
        ),
      ),
    );
  }

  String html = "<html>"
  "<h2>Surprize Terms and conditions</h2>"
  "<p><b>IMPORTANT NOTICE: </b> All terms of use provided here is an electronic record provided to you in the form of electronic contract formed under Information Technology Act,2000. "
   "This agreement doesn't need any form of physical, electronic or digital signature.</p>"

  "<P>This terms of condition are created to govern and legally bind the relationship between you and Suprize by covering the use and access of the surpize application. Any conflict of the terms of this agreement with other document/electronic record will prevail until futher change or modification are notified by us.</P>"
  "<P>We strongly suggest you to read the following terms along with the privacy policy provided by us.</P>"

  "<H5>1. Acceptance of Terms and Use</H5>"
  "<P>&nbsp;&nbsp;&nbsp;&nbsp; a. Creating account/ signing up or using app in any manner means you have agreed to our terms, rules, policies and procedure that are subject to change without any prior notice send to you. As a result, we suggest you to look for our terms and condition time to time.</P>"
  "<P>&nbsp;&nbsp;&nbsp;&nbsp;  b. Certain services may have their own additional terms and agreement which too are subject to change with out any prior notice send to you. </P>"
  "<P>&nbsp;&nbsp;&nbsp;&nbsp;  c. This terms of use are bind to all form of user without limitation to the contributor of the content, winners, or otherwise.</P>"

  "<H5>2. Eligibility</H5>"
  "<P>	In order to participate in the service, you should be at least age of 18. If you are under age 18, you are under any cirumstance, should avoid the use of the app. We hold the right to revoke the service to the people or entity who change their eligibility at any time, in our sole descretion. If the user who uses our app resides, or is currently living under the country governed by the rules where the use of the application of our feature or services is prohibited, or even the user or entity is banned/ prohibited from using the app, we don't held any responsibility but is held by the user. </P>"

  "<h5>3. Registration</h5>"
  "<p>	In order to use our service, user may need to register for an account, or login in via Facebook or Google authentication mechanism (which are a third party services). It is a requirement for a user to provide accurate , up to date and complete information. We have right to deny you access to our services, revoke prizes, or disqualify you from contest, if such requirement is violated.</p>"
  "<p>	You are not allowed to: (i) use or select a name that belongs to other or impersonate person, entity. (ii) use a username that is subject to right of other person with out any authorization. (iii) register with information that is abusive in nature, and intends to harm other people. It is you who take charge of choosing password for account, and is advised to use secure password. You are required to contact us if you wish to delete your account which might take a time due to circumstances until we have decided to incorporate such feature directly in our application. </p>"

  "<h5>4. Content</h5>"
  "<p><b>&nbsp;&nbsp;&nbsp;&nbsp; a. Definition:</b> By content in this terms and condition, we try to refer, but not limited to, information, data, text, photographs, videos, audio clips, written post, notice, notifications, software, scripts, graphics , interactive feature generated or provided on or throught the services. Content also includes User content which is described below</p>"
  "<p><b>&nbsp;&nbsp;&nbsp;&nbsp; b. User content: </b> User content refers to, but not limited to, added, created, uploaded, submitted, distrubuted or posted to the service by the user which is publicly posted or privately sent. The creator of such content, or the user, helds responsible for accuracy of the data, up to date and in compliance to our rules and regulation. You retain ownership to the content, including user content, that is created by you. You admit or acknowledge that by using the services, you account for the risk and hold responsible for the damage, loss or any party resulting there from. We don't gurantee that all the content you create or access will be continue to exist or to be accurate. </p>"
  "<p><b>&nbsp;&nbsp;&nbsp;&nbsp; c. Notices and Restriction:</b>  The service might contain content which are generated or provided by us or our user. Such content are protected by copyrights, trademarks, patent, trade secrets or other proprietary laws. You should abide by such copyright notices, information and notice with regard to the content of the app.</p>"
  "<p><b>&nbsp;&nbsp;&nbsp;&nbsp; d. Use License:</b> Subject to the terms of use, we restrict the user to license, rent, sell (except User content) our content for commerical purpose or in any way that violates third party right.</p>"
  "<p><b>&nbsp;&nbsp;&nbsp;&nbsp; e.License grant:</b> By submitting user content through the services, you herby do and shall grant us a worldwide, non-exclusive, perpetual, royalty free, fully paid, sub licensable and transferable license to use, edit, modify, manipulate, truncate, aggregrate, reproduce, distrubute, prepare derivatie works of, display, perfrom, and otherwise exploit the user content in connection with app,the services  and and our potential future business successor and assigns  including without limitation to the promoting and redistrubuting part of all the app or services in any media format and through any media channels, and also including after you terminate your account or services. To be precise and clear, it includes user content,not limited to such as name, photographs, date of birth, email , phone numbers. You, therefore, provide us to use, edit, modify, reproduce, distrubute and perfomed derivative works of, display and perform such user content even after you terminate your account. You represent and warrant that you provide license to us to your user content which has not violated any privacy rights, publicity rights, copyright, trademark , contract right and is not bounded with legal issue. </p>"
  "<p><b>&nbsp;&nbsp;&nbsp;&nbsp; f. Availability of content:</b> We cannot gurantee that the content will be available on the app or throught the services. We hold right to, but without any obligation to (i) edit or modify, manipulate the content in our sole descrition, any time, without sending notice to you, and also include the reason by the request from the third parties or authorities from such content, and also if you have violated any terms of use, or with out any valid reasons. (ii) to block, delete the content from services.</p>"

 "<h5>5. Rules of conduct</h5>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp; a. Firstly, you promise or legally acknowledge not to use any service for any situation or purposes that is stricted by the terms and conditions. You are sole responsible for any violation in accordance to our services, and your account or services may be terminated, but not limited to, if any terms and conditions are violated. </p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp; b. You shall not upload, download, post or use the content of our app, including without any limitation to user content, that:</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	i. infringes any patent, trademark, trade secret, copyright, right of publicity or other right of any other person.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	ii. use the service for unauthorized purpose, or violates the law including intellectual property law</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		iii. use screen reader technology, algorithms, or any automated technology to intrepret, analyse, research or gain information about a question or submit an answer to the question.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	 iv. you knew was false, misleading, not accourate contact or information</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		v. result in creating multiple fake account that any way harms our services, and other people related or not related to us.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		v. is unlawful, abusive, harrasing, defamotry, deceptive, fradulent, offensive, contains sexual harrasment, obsense, profance, nudity.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	  vi. contains anuthorized advertising junks or bulk email.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		vii. contains viruses,or computer codes, content, program but not limited to them, that is intend to harm our services in whatsoever way.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	  viii. impersonate or try to steal indentity of other person.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;c. You are not allowed to (i) take action that imposes or may impose ( determined by use in our own descrition) as unreasonable or disproportinately large load on our ( our third party provider) infrastructures; (ii) try to interfere, stop , but not limited, to harm our services.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;d. You shall not decipher, decompile or disassemble, reverse engineer our services or app in any way.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;e. We also hold the right to access, read, preserve and disclose any information as we believe if necessary in condition such as (i) sastify any applicable law, regulation, legal process and government reuest, (ii) to investigate of possible violation, (iii) detect, prevent or otherwise address fraud, security or technical issue, (iv)in resposne to request by other user, (v) to protect the right of other user and the public.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;f. If any way, the services is not running as intended or becomes corrupted by the user, we dont hold any resposible. </p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;g. We are always doing our best to organise our services on the app, in effective way. If due to any circumstance, but not limited to such as (i) poor internet connection, (ii) disruption of a service either from us or third party causes quiz not to be perfomed in effective way, we don't held or account responsible.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;h. We dont gurantee that all the result of the service, for instance daily quiz- one of a many part of our services, are accurate. If due to any circumstances, but not limited to - (i) poor internet connection from our player , (ii) unavailablity of our service,  (iii) damaged content in our services,  (iv) bugs on our code,  (v) technical issue on our services causes the result to be inaccurate, we don't held any responsible. We will look at the issue and determine the possible cause, and may or not change the result but doesn't gurantee the accuracy. At that time, any user can send us feedback or contact us. We will investigate the issue and can ( or not) changes to result, if we in our sole descrition, consider it's appropriate to alter the result. </p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;j. The winners are contacted with the email they provided on the app, or if necessary contacted with the phone number the provide us. They should reply us within the 10 days( the number of days can be changed without notice to the user) after we sent email. If they don't, we can cancel the prize of the winner with out any further notice. </p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;h. We don't held responsible in case we fail to send prize or cash to winner, which can be due to but not limited to -  unavailable of resources or services, no contact or reply from user as specified earlier. </p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;i. User of our service acknowledges that there could be delay in sending all available rewards,such as prize or money from our side due to many reasons.</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;j. The system on how we conduct our all the services, or as a service as a whole could change without any notice to users</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;k. We don't gurantee the safe available of the prizes to the winners. We don't send prize through any means of transportation. Only if it is possible or can be send with in the location without any extra charges, we would try to ensure but not gurantee that prizes are received by winners.</p>"

  "<h5>6. Third party services</h5>"
  "<p>The service may permit you to link to or otherwise access other website, services, or resources on your device/ internet. These type of resources are not on our control, and you acknowledge that we don't be responsbile or liable for such content functions accuracy or appropriatness. Our services may be dependent on such services. In case of failure of their services, if it directly or indirectly effect us, you further acknowledge that we are not held responsible.</p>"

  "<h5>7. Terminate: </h5>"
  "<p>We hold access to terminate your access to any part of the service with or without notice. If you wish to terminate your account, you shall contact us. However, there could be delay due to many circumstances. You acknolwedge that you will show patient and wait till we cancel and delete your account.</p>"

  "<h5>8. Warranty Disclamer </h5>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;a. We dont have any special relationship with or fiduciary duty with you. You acknowledge that we have no any duty to take any action regarding:</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;i.  which user has access to our services</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ii. which content you access on our services</p>"
  "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;iii. how you interepet the data</p>"

  "<p>b. You release us from all liability for you having both acquired or not acquired content throught the services. We don't hold responsbile for any accuracy of the contents, copyrights that content in our service. </p>"
  "<p>c. You release from all liability that we are unable to give you services as intented,if such situation occours,due to many possible reasons.</p>"

  "<h5>9. Indemnification</h5>"
  "<p>You need to  defend, indemnify and hold harmless us from all liabilites, claim and expenses , including attorney fees, which  could arise directly or indirectly from your use or misue of, service, content, or otherwise from your user content, violation of terms an duse , infrignment by you, or any third party that is using your account or identity in services, or other right of any person or entity. We hold  the right to assume the exclusive defense and control of any matter otherwise subject to indemnification by use, in which event you will need to  assist and incorporate with us in asserting any available defenses.</p>"

  "<h5>10: Limitation of liability:  </h5>"
  "<p>In no event shall we are held liable under contract, tort,negligence or any other legal or equitable theory with respect to service</p>"

  "<p><b>Effective date of Terms and use:&nbsp</b>September 20, 2019</p>"


              '</html>';
}
