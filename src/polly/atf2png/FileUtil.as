package polly.atf2png 
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 文件操作便捷方法
	 * @author abo
	 */
	public class FileUtil 
	{
		
		public function FileUtil() 
		{
			
		}
		
		public static function savePNGFile(data:BitmapData, file:File):void
		{
			saveImageFile(data, file, new PNGEncoderOptions());
		}
		
		public static function saveJPEGFile(data:BitmapData, file:File):void
		{
			saveImageFile(data, file, new JPEGEncoderOptions(80));
		}
		
		public static function saveImageFile(data:BitmapData, file:File, compressor:Object):void
		{
			if (data == null || file == null || compressor == null) return;
			
			var bytes:ByteArray = data.encode(data.rect, compressor);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
			bytes.clear();
		}
		
		public static function saveXMLFile(xml:XML, file:File):void
		{
			if (xml == null || file == null) return;
			
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes('<?xml version="1.0" encoding="UTF-8"?>\n');
			fs.writeUTFBytes(xml.toXMLString());
			fs.close();
		}
		
		public static function saveSmallAsset(bigData:BitmapData, smallScale:Number, smallFile:File):void
		{
			if (bigData == null || smallScale == 1 || smallFile == null) return;
			
			var m:Matrix = new Matrix();
			m.scale(smallScale, smallScale);
			var smallData:BitmapData = new BitmapData(bigData.width * smallScale, bigData.height * smallScale, true, 0);
			smallData.draw(bigData, m);
			if (smallFile.name.indexOf(".jpg.") != -1)
			{
				saveJPEGFile(smallData, smallFile);
			}
			else
			{
				savePNGFile(smallData, smallFile);
			}
		}
		
		public static function readBinFile(file:File):ByteArray
		{
			if (!file.exists)
			{
				return null;
			}
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian  = Endian.LITTLE_ENDIAN;
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			return bytes;
		}
		
	}

}