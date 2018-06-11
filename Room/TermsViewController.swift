//
//  TermsViewController.swift
//  Room
//
//  Created by Thomas Jensen on 6/10/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var termsTextView: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var decision = false
    
    
    func setTermsString() {
        let formattedString = NSMutableAttributedString()
        formattedString
            .white( //For some reason, this fixes formatting... dont touch!!
                """
                jjnhjvjhhkjjkjklgjhgjhgjhghjgjhghjljgbjhbvjjjhvjbkjkhjbkjbkjbkjbkjbkjbkjbkjbkjbjbhbjhbhjbkj ghjg h h k j jk
                    \n
                """)
            .normal("""
                Please read these Terms of Service carefully before  using the Chateau mobile application operated by us. \n\nYour access to and use of the application is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the app. \n\nBy accessing or using the application you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the application.\n\n
                """)
            .bold("Acknowledgement\n")
            .normal(
                """
                Chateau and you as the End-User acknowledge that these Terms are concluded between Chateau and the End-User only, and not with Apple, and Chateau, not Apple, is solely responsible for the Licensed Application and the content thereof. These Terms may not provide for usage rules that are in conflict with, the App Store Terms of Service as of the Effective Date which Chateau acknowledges that it has had the opportunity to review.\n\n
                """)
            .bold("Termination\n")
            .normal(
                """
                We may terminate or suspend access to our service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms. All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.\n\n
                """)
            .bold("Content\n")
            .normal(
                """
                Our application allows you to post, link, comment, share and otherwise make available certain information, text, or other material. You are responsible for the content you post and interact with on the application. We reserve the right to take down any content that might be inappropriate or disable users at any time. We will have no tolerance for abusive behavior.\n\n
                """)
            .bold("Changes\n")
            .normal(
                """
                We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is made we will try to provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n\n
                """)
            .bold("Warranty\n")
            .normal(
                """
                In the event of any failure of Chateau to conform to any applicable warranty, you as the End-User may notify Apple, and Apple will refund the purchase price for the Chateau to you. To the maximum extent permitted by applicable law, Apple will have no other warranty obligation whatsoever with respect to Chateau, and any other claims, losses, liabilities, damages, costs or expenses attributable to any failure to conform to any warranty are Chateau's sole responsibility.\n\n
                """)
            .bold("Product Claims\n")
            .normal(
                """
                Chateau and you as the End-User acknowledge that Chateau, not Apple, are responsible for addressing any claims of the End-User or any third party relating to Chateau's or the End-User's possession and/or use of Chateau, including, but not limited to: (i) product liability claims; (ii) any claim that the Chateau fails to conform to any applicable legal or regulatory requirement; and (iii) claims arising under consumer protection, privacy, or similar legislation, including in connection with Chateau’s use of the HealthKit and HomeKit frameworks.\n\n
                """)
            .bold("Maintenance and Support\n")
            .normal(
                """
                Chateau is solely responsible for providing any maintenance and support services with respect to the application as required under applicable law. Chateau and you as the End-User acknowledge that Apple has no obligation whatsoever to furnish any maintenance and support services with respect to the Chateau.\n\n
                """)
            .bold("Scope of License\n")
            .normal(
                """
                The license granted to you as the End-User for the Licensed Application (Chateau) is limited to a non-transferable license to use the Licensed Application (Chateau) on any Apple-branded Products that the End-User owns or controls and as permitted by the Usage Rules set forth in the App Store Terms of Service, except that such Chateau may be accessed and used by other accounts associated with the purchaser via Family Sharing or volume purchasing.\n\n
                """)
            .bold("Third Party Beneficiary\n")
            .normal(
                """
                Chateau and you as the End-User acknowledge and agree that Apple, and Apple’s subsidiaries, are third party beneficiaries of the EULA, and that, upon the End-User’s acceptance of the terms and conditions of the EULA, Apple will have the right (and will be deemed to have accepted the right) to enforce the EULA against the End-User as a third party beneficiary thereof.\n\n
                """)
            .bold("Legal Compliance\n")
            .normal(
                """
                By agreeing to these Terms, you represent and warrant that (i) you are not located in a country that is subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a “terrorist supporting” country; and (ii) you are not listed on any U.S. Government list of prohibited or restricted parties.\n\n
                """)
            .bold("Intellectual Property Rights\n")
            .normal(
                """
                Chateau and you as the End-User acknowledge that, in the event of any third party claim that Chateau or the End-User’s possession and use of that infringes that third party’s intellectual property rights, Chateau, not Apple, will be solely responsible for the investigation, defense, settlement and discharge of any such intellectual property infringement claim.\n\n
                """)
            .bold("Contact Us\n")
            .normal(
                """
                If you have any questions about these Terms, please contact us at\n
                    lets.chateau@gmail.com\n
                    Thomas Jensen\n
                    +1 (408) 718 0052\n\n
                """)
            .bold("Last updated: June 2018")
  
        termsTextView.attributedText = formattedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termsTextView.contentOffset = CGPoint(x:0,y:0)
        setTermsString()
        // Do any additional setup after loading the view.
    }

    @IBAction func decline(_ sender: Any) {
        self.decision = false
    }
    @IBAction func accept(_ sender: Any) {
        self.decision = true
    }
    func getDecision() -> Bool {
        return self.decision
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 16)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func white(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 12)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        let whiteString = NSMutableAttributedString(string:text, attributes: attrs)
        append(whiteString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-UltraLight", size: 13)!, NSAttributedStringKey.foregroundColor : UIColor.black]
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
