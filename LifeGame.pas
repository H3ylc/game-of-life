program lifegame;

uses crt;

const
	tick = 100;
type
	Field = array[0..512, 0..512] of boolean;
var
	Now: Field;
	Next: Field;
function CountOfNeighbors(x,y: integer): integer;
begin
	CountOfNeighbors := 0;
	if Now[x+1,y] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x-1,y] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x+1,y+1] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x-1,y-1] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x,y+1] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x,y-1] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x-1,y+1] then
		CountOfNeighbors := CountOfNeighbors + 1;
	if Now[x+1,y-1] then
		CountOfNeighbors := CountOfNeighbors + 1;
end;
procedure WriteCells(f: Field);
var
	x,y: integer;
begin
	for y := 1 to ScreenHeight do
	begin
		for x := 1 to ScreenWidth do
		begin
			if f[x,y] then
			begin
				GotoXY(x,y);
				write('@');
				GotoXY(1,1);
			end;
			{else
			begin
				GotoXY(x,y);
				write(' ');
				GotoXY(1,1)
			end;}
		end;
	end;
end;
procedure DeathOrLife(x, y: integer);
var
	count: integer;
begin
	count := CountOfNeighbors(x,y);
	if (count < 2) or (count > 3) then
		Next[x,y] := false
	else
		Next[x,y] := true;
end;

procedure NewLife(x, y: integer);
var
	count: integer;
begin
	count := CountOfNeighbors(x,y);
	if count = 3 then
		Next[x,y] := true
	else
		Next[x,y] := false

end;

procedure Cycle;
var
	x,y: integer;
begin
	for y := 1 to ScreenHeight do
	begin
		for x := 1 to ScreenWidth do
		begin
			if Now[x,y] then
				DeathOrLife(x,y)
			else
				NewLife(x,y);
		end;
	end;
end;

procedure Movement(var x, y: integer; dx, dy: integer);
begin
	if not((x + dx < 0) or (x + dx > ScreenWidth) or  
	(y + dy < 0) or (y + dy > ScreenHeight)) then  
	begin
		x := x + dx;
		y := y + dy;
		GotoXY(x, y);
	end;
end;

procedure CreateNewLife(x,y: integer);
begin
	write('@');
	Now[x,y] := true;
	GotoXY(x,y)
end;

procedure DestroyLife(x,y: integer);
begin
	write(' ');
	Now[x,y] := false;
	GotoXY(x,y)
end;

var
	key: char;
	x,y,i: integer;
begin
	clrscr();
	Now[26,7] := true;
	Now[27,8] := true;
	Now[28,8] := true;
	Now[26,9] := true;
	Now[27,9] := true;
	WriteCells(Now);
	x := 1;
	y := 1;
	while true do
	begin
		key := ReadKey();
		case key of
		'q': begin
			clrscr();
			halt();
		end;
		'c': begin
			for i := 1 to 100 do
			begin
				delay(tick);
				Cycle;
				Now := Next;
				clrscr();
				WriteCells(Now);
			end;
		end;
		'w': Movement(x, y, 0, -1);
		'a': Movement(x, y, -1, 0);
		's': Movement(x, y, 0, 1);
		'd': Movement(x, y, 1, 0);
		'z': CreateNewLife(x,y);
		'x': DestroyLife(x,y);
	end;
end;
ReadKey();
clrscr();
end.

