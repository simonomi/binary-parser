import BinaryParser
import Foundation

@BinaryConvertible
struct DEX {
	var numberOfScenes: UInt32
	var sceneOffsetsStart: UInt32
	@Count(givenBy: \Self.numberOfScenes)
	@Offset(givenBy: \Self.sceneOffsetsStart)
	var sceneOffsets: [UInt32]
	@Offsets(givenBy: \Self.sceneOffsets)
	var script: [Scene]
	
	@BinaryConvertible
	struct Scene {
		var numberOfCommands: UInt32
		var offsetsOffset: UInt32
		@Count(givenBy: \Self.numberOfCommands)
		@Offset(givenBy: \Self.offsetsOffset)
		var commandOffsets: [UInt32]
		@Offsets(givenBy: \Self.commandOffsets)
		var commands: [Command]
		
		@BinaryConvertible
		struct Command {
			var type: UInt32
			var numberOfArguments: UInt32
			var argumentsStart: UInt32
			@Count(givenBy: \Self.numberOfArguments)
			@Offset(givenBy: \Self.argumentsStart)
			var arguments: [UInt32]
		}
	}
}

@BinaryConvertible
struct DMG {
	var magicBytes = "DMG"
	var stringCount: UInt32
	var indexesOffset: UInt32
	@Count(givenBy: \Self.stringCount)
	@Offset(givenBy: \Self.indexesOffset)
	var indexes: [UInt32]
	@Offsets(givenBy: \Self.indexes)
	var strings: [DMGString]
	
	@BinaryConvertible
	struct DMGString {
		var index: UInt32
		var stringOffset: UInt32
		@Offset(givenBy: \Self.stringOffset)
		var string: String
	}
}

@BinaryConvertible
struct DMS {
	var magicBytes = "DMS"
	var value: UInt32
}

@BinaryConvertible
struct DTX {
	var magicBytes = "DTX"
	var stringCount: UInt32
	var indexesOffset: UInt32
	@Count(givenBy: \Self.stringCount)
	@Offset(givenBy: \Self.indexesOffset)
	var indexes: [UInt32]
	@Offsets(givenBy: \Self.indexes)
	var strings: [String]
}

@BinaryConvertible
struct MAR {
	var magicBytes = "MAR"
	var fileCount: UInt32
	@Count(givenBy: \Self.fileCount)
	var indexes: [Index]
	@Offsets(givenBy: \Self.indexes, at: \.fileOffset)
	var files: [MCM]
	
	@BinaryConvertible
	struct Index {
		var fileOffset: UInt32
		var decompressedSize: UInt32
	}
}

@BinaryConvertible
struct MCM {
	var magicBytes = "MCM"
	var decompressedSize: UInt32
	var maxSizePerChunk: UInt32
	var chunkCount: UInt32
	var compressionType1: UInt8
	var compressionType2: UInt8
	@Padding(bytes: 2)
	@Count(givenBy: \Self.chunkCount)
	var chunkOffsets: [UInt32]
	var endOfFileOffset: UInt32
	@Offsets(givenBy: \Self.chunkOffsets)
	@EndOffset(givenBy: \Self.endOfFileOffset)
	var chunks: [Data]
}

@BinaryConvertible
struct MM3 {
	var magicBytes = "MM3"
	var index1: UInt32
	var tableFileName1Offset: UInt32
	var index2: UInt32
	var tableFileName2Offset: UInt32
	var index3: UInt32
	var tableFileName3Offset: UInt32
	@Offset(givenBy: \Self.tableFileName1Offset)
	var tableFileName1: String
	@Offset(givenBy: \Self.tableFileName2Offset)
	var tableFileName2: String
	@Offset(givenBy: \Self.tableFileName3Offset)
	var tableFileName3: String
}

@BinaryConvertible
struct MPM {
	var magicBytes = "MPM"
	var unknown1: UInt32
	var unknown2: UInt32
	var unknown3: UInt32
	var width: UInt32
	var height: UInt32
	var unknown4: UInt32
	var unknown5: UInt32
	var unknown6: UInt32
	var index1: UInt32
	var tableFileName1Offset: UInt32
	var index2: UInt32
	var tableFileName2Offset: UInt32
	var index3: UInt32
	var tableFileName3Offset: UInt32
	@Offset(givenBy: \Self.tableFileName1Offset)
	var tableFileName1: String
	@Offset(givenBy: \Self.tableFileName2Offset)
	var tableFileName2: String
	@Offset(givenBy: \Self.tableFileName3Offset)
	var tableFileName3: String
}

@BinaryConvertible
struct NDS {}

@BinaryConvertible
struct RLS {
	var magicBytes = "RLS"
	var kasekiCount: UInt32
	var offsetsStart: UInt32
	@Count(givenBy: \Self.kasekiCount)
	@Offset(givenBy: \Self.offsetsStart)
	var offsets: [UInt32]
	@Offsets(givenBy: \Self.offsets)
	var kasekis: [Kaseki]
	
	@BinaryConvertible
	struct Kaseki {
		var isEntry: UInt8
		var unknown1: UInt8
		var unbreakable: UInt8
		var destroyable: UInt8
		
		var unknown2: UInt8
		var unknown3: UInt8
		var unknown4: UInt8
		var unknown5: UInt8
		
		var fossilImage: UInt32
		var rockImage: UInt32
		var fossilConfig: UInt32
		var rockConfig: UInt32
		var buyPrice: UInt32
		var sellPrice: UInt32
		
		var unknown6: UInt32
		var unknown7: UInt32
		var fossilName: UInt32
		var unknown8: UInt32
		
		var time: UInt32
		var passingScore: UInt32
		
		var unknown9: UInt32
		var unknown10: UInt32
		var unknown11: UInt32
		
		@If(\Self.isEntry, is: 1)
		var unknown14: UInt32?
		@If(\Self.isEntry, is: 1)
		var unknown15: UInt32?
	}
}

//let dtxData = MyData([
//	0x44, 0x54, 0x58, 0x00,
//	0x02, 0x00, 0x00, 0x00,
//	0x0C, 0x00, 0x00, 0x00,
//	0x14, 0x00, 0x00, 0x00,
//	0x18, 0x00, 0x00, 0x00,
//	0x44, 0x54, 0x58, 0x00,
//	0x48, 0x65, 0x6C, 0x6C,
//	0x6F, 0x2C, 0x20, 0x57,
//	0x6F, 0x72, 0x6C, 0x64,
//	0x21, 0x00
//])

//let marData = MyData(try Data(contentsOf: URL(filePath: "/Users/simonomi/ff1/japanese")))
//let start = Date.now
//let mar = try marData.read(MAR.self)
//print(-start.timeIntervalSinceNow)
//print(mar)

//let dtxData = MyData(try Data(contentsOf: URL(filePath: "/Users/simonomi/ff1/japanese")))
//let start = Date.now
//let dtx = try dtxData.read(DTX.self)
//print(-start.timeIntervalSinceNow)
//print(dtx)

//let marData = MyData(try Data(contentsOf: URL(filePath: "/Users/simonomi/ff1/kaseki_defs")))
//let start = Date.now
//let mar = try marData.read(MAR.self)
//print(-start.timeIntervalSinceNow)
//print(mar)

//let rlsData = MyData(try Data(contentsOf: URL(filePath: "/Users/simonomi/ff1/kaseki_defs")))
//let start = Date.now
//let rls = try rlsData.read(RLS.self)
//print(-start.timeIntervalSinceNow)
//print(rls)
