/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class PersistencyManager: NSObject {
  private var albums : [Album] = []

  override init() {
    super.init()
    if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")) {
      let unarchiveAlbums = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Album]?
      if let unwrappedAlbum = unarchiveAlbums {
        albums = unwrappedAlbum
      }
    } else {
      createPlaceholderAlbum()
    }
  }

  func createPlaceholderAlbum() {
    //Dummy list of albums
    let album1 = Album(title: "Best of Bowie",
                       artist: "David Bowie",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png",
                       year: "1992")
    
    let album2 = Album(title: "Like a Virgin",
                       artist: "Madonna",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_big_daddy_la_musique_de_paris_derniere_2.png",
                       year: "2003")
    
    let album3 = Album(title: "Nothing Like The Sun",
                       artist: "Sting",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_sting_nothing_like_the_sun.png",
                       year: "1999")
    
    let album4 = Album(title: "Staring at the Sun",
                       artist: "U2",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_u2_staring_at_the_sun.png",
                       year: "2000")
    
    let album5 = Album(title: "American Pie",
                       artist: "Madonna",
                       genre: "Pop",
                       coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png",
                       year: "2000")
    albums = [album1, album2, album3, album4, album5]
    saveAlbums()
  }

  func getAlbums() -> [Album] {
    return albums
  }

  func addAlbum(album: Album, index: Int) {
    if (albums.count >= index) {
      albums.insert(album, atIndex: index)
    } else {
      albums.append(album)
    }
  }

  func deleteAlbumAtIndex(index: Int) {
    albums.removeAtIndex(index)
  }

  func saveImage(image: UIImage, filename: String) {
    let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
    let data = UIImagePNGRepresentation(image)
    data!.writeToFile(path, atomically: true)
  }

  func getImage(filename: String) -> UIImage? {
    let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
    do{
        let data = try NSData(contentsOfFile: path, options: .UncachedRead)
        return UIImage(data: data)
    }catch{
        return nil
    }
  }

  func saveAlbums() {
    let filename = NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")
    let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
    data.writeToFile(filename, atomically: true)
  }

}
