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
struct NDS {
	var header: Header
	
	@Offset(givenBy: \Self.header.arm9Offset)
	@Length(givenBy: \Self.header.arm9Size)
	var arm9: Data
	@Offset(givenBy: \Self.header.arm9OverlayOffset)
	@Count(givenBy: \Self.header.arm9OverlaySize, .dividedBy(32))
	var arm9OverlayTable: [OverlayTableEntry]
	
	@Offset(givenBy: \Self.header.arm7Offset)
	@Length(givenBy: \Self.header.arm7Size)
	var arm7: Data
	@Offset(givenBy: \Self.header.arm7OverlayOffset)
	@Count(givenBy: \Self.header.arm7OverlaySize, .dividedBy(32))
	var arm7OverlayTable: [OverlayTableEntry]
	
	@Offset(givenBy: \Self.header.iconBannerOffset)
	@Length(0x840) // hardcoded for version 1
	var iconBanner: Data
	
	@Offset(givenBy: \Self.header.fileNameTableOffset)
	var fileNameTable: FileNameTable
	
	@Offset(givenBy: \Self.header.fileAllocationTableOffset)
	@Count(givenBy: \Self.header.fileAllocationTableSize, .dividedBy(8))
	var fileAllocationTable: [FileAllocationTableEntry]
	
	@BinaryConvertible
	struct Header {
		@Length(12)
		var gameTitle: String
		@Length(4)
		var gamecode: String
		@Length(2)
		var makercode: String
		var unitcode: UInt8
		var encryptionSeedSelect: UInt8
		var deviceCapacity: UInt8
		@Padding(bytes: 7) // reserved
		var ndsRegion: UInt16
		var romVersion: UInt8
		var internalFlags: UInt8
		var arm9Offset: UInt32
		var arm9EntryAddress: UInt32
		var arm9LoadAddress: UInt32
		var arm9Size: UInt32
		var arm7Offset: UInt32
		var arm7EntryAddress: UInt32
		var arm7LoadAddress: UInt32
		var arm7Size: UInt32
		var fileNameTableOffset: UInt32
		var fileNameTableSize: UInt32
		var fileAllocationTableOffset: UInt32
		var fileAllocationTableSize: UInt32
		var arm9OverlayOffset: UInt32
		var arm9OverlaySize: UInt32
		var arm7OverlayOffset: UInt32
		var arm7OverlaySize: UInt32
		var normalCardControlRegisterSettings: UInt32
		var secureCardControlRegisterSettings: UInt32
		var iconBannerOffset: UInt32
		var secureAreaCRC: UInt16
		var secureTransferTimeout: UInt16
		var arm9Autoload: UInt32
		var arm7Autoload: UInt32
		var secureDisable: UInt64
		var totalROMSize: UInt32
		var headerSize: UInt32
		@Padding(bytes: 212) // 56: reserved, 156: nintendo logo
		var nintendoLogoCRC: UInt16
		var headerCRC: UInt16
//		@Padding(bytes: 32) // debugger reserved
//		var nothing: Empty
	}
	
	@BinaryConvertible
	struct OverlayTableEntry {
		var id: UInt32
		var loadAddress: UInt32
		var size: UInt32
		var bssSize: UInt32
		var staticInitializerStartAddress: UInt32
		var staticInitializerEndAddress: UInt32
		var fileId: UInt32
		var reserved: UInt32
	}
	
	@BinaryConvertible
	struct FileNameTable {
		var rootFolder: MainEntry
		@Count(givenBy: \Self.rootFolder.parentId, .minus(1))
		var mainTable: [MainEntry]
		@Offsets(givenBy: \Self.mainTable, at: \.subTableOffset)
		var subTable: [[SubEntry]]
		
		@BinaryConvertible
		struct MainEntry {
			var subTableOffset: UInt32
			var firstChildId: UInt16
			var parentId: UInt16 // for first entry, number of folders instead of parent id
		}
		
		@BinaryConvertible
		struct SubEntry {
			var typeAndNameLength: UInt8
			@Length(givenBy: \Self.typeAndNameLength, .modulo(0x80))
			var name: String
			@If(\Self.typeAndNameLength, is: .greaterThan(0x80))
			var id: UInt16?
		}
	}
	
	@BinaryConvertible
	struct FileAllocationTableEntry {
		var startAddress: UInt32
		var endAddress: UInt32
	}
}

extension [NDS.FileNameTable.SubEntry]: BinaryConvertible {
	public init(from data: BinaryParser.MyData) throws {
		self = []
		
		while last?.typeAndNameLength != 0 {
			append(try data.read(NDS.FileNameTable.SubEntry.self))
		}
		removeLast()
	}
}

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
		
		@If(\Self.isEntry, is: .equalTo(1))
		var unknown14: UInt32?
		@If(\Self.isEntry, is: .equalTo(1))
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

let ndsData = MyData(try Data(contentsOf: URL(filePath: "/Users/simonomi/ff1/Fossil Fighters.nds")))
let start = Date.now
let nds = try ndsData.read(NDS.self)
print(-start.timeIntervalSinceNow)
//print(nds)
