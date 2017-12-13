import UIKit

extension UIApplication {
    
    /// Build version. Eg 234.
    public func em_buildVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    /// iTunes version. Eg. 1.3.0
    public func em_itunesVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// Version with build number. Eg. 1.3.0 (234)
    public func em_completeVersion() -> String {
        return "\(em_itunesVersion()) (\(em_buildVersion()))"
    }
    
    public func em_pathForDirectoryType(direcotry directory: FileManager.SearchPathDirectory) -> String {
        var dirPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).last
        
        if directory == .applicationSupportDirectory || directory == .cachesDirectory {
            let applicationName = Bundle.main.infoDictionary?[kCFBundleNameKey as String]
            dirPath = dirPath?.appending(applicationName as! String)
        }
        
        let manager = FileManager.default
        if manager.fileExists(atPath: dirPath!) == false {
            try? manager.createDirectory(at: URL(fileURLWithPath: dirPath!), withIntermediateDirectories: true, attributes: nil)
        }
        
        return dirPath!
    }
//    +(NSString*) em_pathForDirectoryType:(NSSearchPathDirectory)inDirectoryType
//    {
//    NSString* dirPath = [NSSearchPathForDirectoriesInDomains(inDirectoryType, NSUserDomainMask, YES) lastObject];
//    
//    if(inDirectoryType == NSApplicationSupportDirectory || inDirectoryType == NSCachesDirectory){
//    NSString* applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
//    dirPath = [dirPath stringByAppendingPathComponent:applicationName];
//    }
//    
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if([manager fileExistsAtPath:dirPath] == NO){
//    [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
//    }
//    
//    return dirPath;
//    }
//
//    +(NSString*) em_pathForDocuments
//    {
//    return [UIApplication em_pathForDirectoryType:NSDocumentDirectory];
//    }
    
    public func em_pathForDocuments() -> String {
        return em_pathForDirectoryType(direcotry: .documentDirectory)
    }
}
