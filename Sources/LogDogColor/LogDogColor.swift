import LogDog
import Chalk

public extension LogSink where Output == String {
    func color(_ color: @escaping (Logger.Level) -> TerminalColor = LogFormatters.Color.preferredColor(for:)) -> LogSinks.Concat<Self, LogFormatters.Color> {
        self + .init(color: color)
    }
}

public extension LogFormatters {
    struct Color: LogSink {
        public typealias Input = String
        public typealias Output = String
        
        public let color: (Logger.Level) -> TerminalColor

        public init(color: @escaping (Logger.Level) -> TerminalColor) {
            self.color = color
        }

        public func sink(_ record: LogRecord<String>, next: @escaping LogSinkNext<String>) {
            record.sink(next: next) { record in
                Style(fgColor: self.color(record.entry.level)).on(record.output).description
            }
        }
    }
}

extension LogFormatters.Color {
    public static func preferredColor(for level: Logger.Level) -> Color {
        switch level {
        case .trace:
            return Color.Material.grey
        case .debug:
            return Color.Material.blueGrey
        case .info:
            return Color.Material.lightBlue
        case .notice:
            return Color.Material.blue
        case .warning:
            return Color.Material.yellow
        case .error:
            return Color.Material.orange
        case .critical:
            return Color.Material.red
        }
    }
}


