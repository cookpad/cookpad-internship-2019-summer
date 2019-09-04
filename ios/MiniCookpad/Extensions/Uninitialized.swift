//
// Copyright © Cookpad Inc. All rights reserved.
//

import Foundation

func uninitialized<T>(message: String = "") -> T {
    fatalError("Fatal error: The property was referenced before being initialized. \(message)")
}
