/**
 * Functions that control the plural command.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

/// Inserts the plural of a valid noun in the command bar into the proxy.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func queryPlural(commandBar: UILabel) {
  // Cancel via a return press.
  if commandBar.text! == pluralPromptAndCursor || commandBar.text! == pluralPromptAndPlaceholder {
    return
  }
  var noun: String = (commandBar.text!.substring(
    with: pluralPrompt.count ..< ((commandBar.text!.count) - 1))
  )
  noun = String(noun.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase plural.
  inputWordIsCapitalized = false
  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    inputWordIsCapitalized = noun.substring(toIdx: 1).isUppercase
    noun = noun.lowercased()
  }

  let query = "SELECT * FROM nouns WHERE noun = ?"
  let args = [noun]
  let outputCols = ["plural"]
  wordToReturn = queryDBRow(query: query, outputCols: outputCols, args: args)[0]

  if wordToReturn != "" {
    if wordToReturn != "isPlural" {
      if inputWordIsCapitalized {
        proxy.insertText(wordToReturn.capitalized + " ")
      } else {
        proxy.insertText(wordToReturn + " ")
      }
    } else {
      proxy.insertText(noun + " ")
      commandState = .alreadyPlural
    }
  } else {
    commandState = .invalid
  }
}
