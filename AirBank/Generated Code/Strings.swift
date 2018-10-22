// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Account {
    internal enum BankCode {
      /// bank code
      internal static let caption = L10n.tr("Localizable", "account.bankCode.caption")
    }
    internal enum Name {
      /// account name
      internal static let caption = L10n.tr("Localizable", "account.name.caption")
    }
    internal enum Number {
      /// account number
      internal static let caption = L10n.tr("Localizable", "account.number.caption")
    }
  }

  internal enum Error {
    internal enum Network {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "error.network.cancel")
      /// Retry
      internal static let retry = L10n.tr("Localizable", "error.network.retry")
      /// Something went wrong
      internal static let title = L10n.tr("Localizable", "error.network.title")
    }
  }

  internal enum Filter {
    /// All
    internal static let all = L10n.tr("Localizable", "filter.all")
    /// Incoming
    internal static let incoming = L10n.tr("Localizable", "filter.incoming")
    /// Outgoing
    internal static let outgoing = L10n.tr("Localizable", "filter.outgoing")
  }

  internal enum Networking {
    internal enum Error {
      /// Requested item was not found
      internal static let notFound = L10n.tr("Localizable", "networking.error.notFound")
    }
  }

  internal enum Title {
    /// Detail
    internal static let detail = L10n.tr("Localizable", "title.detail")
    /// List
    internal static let list = L10n.tr("Localizable", "title.list")
  }

  internal enum Transaction {
    /// Incoming
    internal static let incoming = L10n.tr("Localizable", "transaction.INCOMING")
    /// Outgoing
    internal static let outgoing = L10n.tr("Localizable", "transaction.OUTGOING")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
