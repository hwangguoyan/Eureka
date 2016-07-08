//  CallbacksTests.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import XCTest
@testable import Eureka

class CallbacksTests: XCTestCase {
    
    var formVC = FormViewController()
    
    override func setUp() {
        super.setUp()
        // load the view to test the cells
        formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        formVC.tableView?.frame = formVC.view.frame
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOnChange() {
        onChangeTest(row:TextRow(), value: "text")
        onChangeTest(row:IntRow(), value: 33)
        onChangeTest(row:DecimalRow(), value: 35.7)
        onChangeTest(row:URLRow(), value: NSURL(string: "http://xmartlabs.com")! as URL)
        onChangeTest(row:DateRow(), value: NSDate().addingTimeInterval(100) as Date)
        onChangeTest(row:DateInlineRow(), value: NSDate().addingTimeInterval(100) as Date)
        onChangeTest(row:PopoverSelectorRow<String>(), value: "text")
        onChangeTest(row:PostalAddressRow(), value: PostalAddress(street: "a", state: "b", postalCode: "c", city: "d", country: "e"))
        onChangeTest(row:SliderRow(), value: 5.0)
        onChangeTest(row:StepperRow(), value: 2.5)
    }
    
    func testCellSetup() {
        cellSetupTest(row:TextRow())
        cellSetupTest(row:IntRow())
        cellSetupTest(row:DecimalRow())
        cellSetupTest(row:URLRow())
        cellSetupTest(row:DateRow())
        cellSetupTest(row:DateInlineRow())
        cellSetupTest(row:PopoverSelectorRow<String>())
        cellSetupTest(row:PostalAddressRow())
        cellSetupTest(row:SliderRow())
        cellSetupTest(row:StepperRow())
    }
    
    func testCellUpdate() {
        cellUpdateTest(row:TextRow())
        cellUpdateTest(row:IntRow())
        cellUpdateTest(row:DecimalRow())
        cellUpdateTest(row:URLRow())
        cellUpdateTest(row:DateRow())
        cellUpdateTest(row:DateInlineRow())
        cellUpdateTest(row:PopoverSelectorRow<String>())
        cellUpdateTest(row:PostalAddressRow())
        cellUpdateTest(row:SliderRow())
        cellUpdateTest(row:StepperRow())
    }
    
    func testDefaultCellSetup() {
        defaultCellSetupTest(row:TextRow())
        defaultCellSetupTest(row:IntRow())
        defaultCellSetupTest(row:DecimalRow())
        defaultCellSetupTest(row:URLRow())
        defaultCellSetupTest(row:DateRow())
        defaultCellSetupTest(row:DateInlineRow())
        defaultCellSetupTest(row:PopoverSelectorRow<String>())
        defaultCellSetupTest(row:PostalAddressRow())
        defaultCellSetupTest(row:SliderRow())
        defaultCellSetupTest(row:StepperRow())
    }
    
    func testDefaultCellUpdate() {
       defaultCellUpdateTest(row: TextRow())
       defaultCellUpdateTest(row: IntRow())
       defaultCellUpdateTest(row: DecimalRow())
       defaultCellUpdateTest(row: URLRow())
       defaultCellUpdateTest(row: DateRow())
       defaultCellUpdateTest(row: DateInlineRow())
       defaultCellUpdateTest(row: PopoverSelectorRow<String>())
       defaultCellUpdateTest(row: PostalAddressRow())
       defaultCellUpdateTest(row: SliderRow())
       defaultCellUpdateTest(row: StepperRow())
    }
    
    func testDefaultInitializers() {
       defaultInitializerTest(row: TextRow())
       defaultInitializerTest(row: IntRow())
       defaultInitializerTest(row: DecimalRow())
       defaultInitializerTest(row: URLRow())
       defaultInitializerTest(row: DateRow())
       defaultInitializerTest(row: DateInlineRow())
       defaultInitializerTest(row: PopoverSelectorRow<String>())
       defaultInitializerTest(row: PostalAddressRow())
       defaultInitializerTest(row: SliderRow())
       defaultInitializerTest(row: StepperRow())
    }
    
    private func onChangeTest<Row, Value where Row: BaseRow, Row: RowType, Row: TypedRowType, Value == Row.Cell.Value>(row:Row, value:Value){
        var invoked = false
        row.onChange { row in
            invoked = true
        }
        formVC.form +++ Section() <<< row
        row.value = value
        XCTAssertTrue(invoked)
    }
    
    private func cellSetupTest<Row, Value where  Row: BaseRow, Row : RowType, Row: TypedRowType, Value == Row.Cell.Value>(row:Row){
        var invoked = false
        row.cellSetup { cell, row in
            invoked = true
        }
        formVC.form +++ Section() <<< row
        let _ = row.cell // laod cell
        XCTAssertTrue(invoked)
    }
    
    private func cellUpdateTest<Row, Value where  Row: BaseRow, Row : RowType, Row: TypedRowType, Value == Row.Cell.Value>(row:Row){
        var invoked = false
        row.cellUpdate { cell, row in
            invoked = true
        }
        formVC.form +++ Section() <<< row
        let _ = formVC.tableView(formVC.tableView!, cellForRowAt: row.indexPath()!) // should invoke cell update
        XCTAssertTrue(invoked)
    }
    
    private func defaultInitializerTest<Row where Row: BaseRow, Row : RowType,  Row: TypedRowType>(row:Row){
        var invoked = false
        Row.defaultRowInitializer = { row in
            invoked = true
        }
        formVC.form +++ Row.init() { _ in }
        XCTAssertTrue(invoked)
    }
    
    private func defaultCellSetupTest<Row where Row: BaseRow, Row: RowType,  Row: TypedRowType>(row:Row){
        var invoked = false
        Row.defaultCellSetup = { cell, row in
            invoked = true
        }
        formVC.form +++ row
        let _ = row.cell // laod cell
        XCTAssertTrue(invoked)
    }

    private func defaultCellUpdateTest<Row where Row: BaseRow, Row : RowType, Row: TypedRowType>(row:Row){
        var invoked = false
        Row.defaultCellUpdate = { cell, row in
            invoked = true
        }
        formVC.form +++ row
        let _ = formVC.tableView(formVC.tableView!, cellForRowAt: row.indexPath()!) // should invoke cell update
        XCTAssertTrue(invoked)
    }
}
