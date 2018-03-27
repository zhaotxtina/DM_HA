% --------------------------------------------------------------------
% DeleteEmptyExcelSheets: deletes all empty sheets in the active workbook.
% This function looped through all sheets and deletes those sheets that are
% empty. Can be used to clean a newly created xls-file after all results
% have been saved in it.
function DeleteEmptyExcelSheets(excelObject)
% 	excelObject = actxserver('Excel.Application');
% 	excelWorkbook = excelObject.workbooks.Open(fileName);
	worksheets = excelObject.sheets;
	sheetIdx = 1;
	sheetIdx2 = 1;
	numSheets = worksheets.Count;
	% Prevent beeps from sounding if we try to delete a non-empty worksheet.
	excelObject.EnableSound = false;

	% Loop over all sheets
	while sheetIdx2 <= numSheets
		% Saves the current number of sheets in the workbook
		temp = worksheets.count;
		% Check whether the current worksheet is the last one. As there always
		% need to be at least one worksheet in an xls-file the last sheet must
		% not be deleted.
		if or(sheetIdx>1,numSheets-sheetIdx2>0)
			% worksheets.Item(sheetIdx).UsedRange.Count is the number of used cells.
			% This will be 1 for an empty sheet.  It may also be one for certain other
			% cases but in those cases, it will beep and not actually delete the sheet.
			if worksheets.Item(sheetIdx).UsedRange.Count == 1
				worksheets.Item(sheetIdx).Delete;
			end
		end
		% Check whether the number of sheets has changed. If this is not the
		% case the counter "sheetIdx" is increased by one.
		if temp == worksheets.count;
			sheetIdx = sheetIdx + 1;
		end
		sheetIdx2 = sheetIdx2 + 1; % prevent endless loop...
	end
	excelObject.EnableSound = true;
	return;
