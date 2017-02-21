//
//  PBRegex.swift
//  MCPM
//
//  Created by Armin Hamar on 04.07.16.
//  Copyright © 2016 Projekt_Blue. All rights reserved.
//
import Foundation

class PBRegex
{
    let pattern:String;
    let regularExpression:NSRegularExpression;
    
    init(_ pattern:String)
    {
        self.pattern = pattern;
        do{
            self.regularExpression = try NSRegularExpression(pattern: pattern, options: []);
        }
        catch
        {
            self.regularExpression = try! NSRegularExpression(pattern: "^()",options: []);
            print("Error when Regular Expression will be Created");
        }
    }
    
    func PBMatchBool(text:String) -> Bool {
        let result = regularExpression.matches(in: text, options: [], range: NSRange(location: 0,length: text.utf16.count));
        var resultranges:[NSRange] = [];
        for ranges in result
        {
            resultranges.append(ranges.range);
        }
        
        if resultranges.count >= 1
        {
            return true;
        }
        return false;
    }
    
    func PBMatchParam(text:String) -> [String] {
        let result = regularExpression.matches(in: text, options: [], range: NSRange(location: 0,length: text.characters.count));
        let nstring = text as NSString;
        var content:[String] = [""];
        var resultranges:[NSRange] = [];
        for ranges in result
        {
            resultranges.append(ranges.range);
        }
        for singelrange in resultranges {
            content.append(nstring.substring(with: singelrange));
        }
        content.remove(at: 0);
        
        return content;
    }
    
    func PBMatchCapture(text:String) -> [String]
    {
        let txtRange = NSMakeRange(0,text.lengthOfBytes(using: .utf8))
        var result = [String]();
        let matchs = regularExpression.matches(in: text, options: .reportCompletion, range: txtRange)
        
        for i in 1..<matchs[0].numberOfRanges
        {
            result.append((text as NSString).substring(with: matchs[0].rangeAt(i)))
        }
        return result;
    }
    
    func PBMatchBoolConsume( text:inout String) throws ->  Bool {
        enum errors: Error
        {
            case IsNotinRangePBMatchBoolConsume
        }
        
        let matching:Bool = PBMatchBool(text: text);
        if matching {
            text = regularExpression.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0,length: text.utf8.count), withTemplate: "");
        }
        else
        {
            throw errors.IsNotinRangePBMatchBoolConsume;
        }
        return matching;
    }
    
    func PBMatchParamConsume( text:inout String) throws -> [String] {
        enum errors: Error
        {
            case IsNotinRange
        }
        let result = regularExpression.matches(in: text, options: [] , range: NSRange(location: 0,length: text.utf8.count));
        let nstring = text as NSString;
        let matching = PBMatchBool(text: text);
        var content:[String] = [""];
        var resultranges:[NSRange] = [];
        for ranges in result
        {
            resultranges.append(ranges.range);
        }
        for singelrange in resultranges {
            content.append(nstring.substring(with: singelrange));
        }
        content.remove(at: 0);
        if matching
        {
            text = regularExpression.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0,length: text.utf16.count), withTemplate: "");
        }
        else
        {
            throw errors.IsNotinRange;
        }
        
        return content;
    }
    
}


func PBMatchBool(text:String,pattern:String) -> Bool {
    let Val = PBRegex(pattern);
    return Val.PBMatchBool(text: text);
}

func PBMatchBoolConsume( text:inout String,pattern:String) -> Bool {
    let Val = PBRegex(pattern);
    return try! Val.PBMatchBoolConsume(text: &text);
}

func PBMatchParamConsume( text:inout String,pattern:String) -> [String] {
    let Val = PBRegex(pattern);
    return try! Val.PBMatchParamConsume(text: &text);
}

func PBMatchParam(text:String,pattern:String) -> [String] {
    let Val = PBRegex(pattern);
    return Val.PBMatchParam(text: text);
}


func PBMatchCapture(text:String,pattern:String) -> [String]
{
    let Val = PBRegex(pattern);
    if Val.PBMatchBool(text: text)
    {
        return Val.PBMatchCapture(text: text);
    }
    return [String]();
}

extension String {
    func substring(from:Int,to:Int) throws -> String
    {
        if from > -1
        {
            if from > to
            {
                return "0";
            }
            else
            {
                let start = self.index(self.startIndex, offsetBy: from);
                let end = self.index(self.startIndex, offsetBy: to);
                return self[start...end];
            }
        }
        else
        {
            return self;
        }
    }
    func substring(to:Int) -> String
    {
        let end = self.index(self.startIndex, offsetBy: to);
        return self[self.startIndex...end];
    }
    
}
