/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

import $.setup;
sq := setup.sq('hthor');

IMPORT Std;

//Daft test of fetch retrieving a dataset
myPeople := sq.SimplePersonBookDs(surname <> '');

recfp := {unsigned8 rfpos, sq.SimplePersonBookDs};
recfp makeRec(sq.SimplePersonBookDs L, myPeople R) := TRANSFORM
    self.rfpos := R.filepos;
    self := L;
END;

recfp makeRec2(sq.SimplePersonBookDs L, myPeople R) := TRANSFORM
    self.rfpos := R.filepos;
    self.books := L.books;
    self := [];
END;

recfp makeRec3(sq.SimplePersonBookDs L, myPeople R) := TRANSFORM
    self.rfpos := R.filepos;
    self.books := L.books+R.books;
    self := L;
END;

fetched := fetch(sq.SimplePersonBookDs, myPeople, right.filepos, makeRec(left, right));
fetched2 := fetch(sq.SimplePersonBookDs, myPeople, right.filepos, makeRec2(left, right));
fetched3 := fetch(sq.SimplePersonBookDs, myPeople, right.filepos, makeRec3(left, right));

recordof(sq.SimplePersonBookDs) removeFp(recfp l) := TRANSFORM
    SELF := l;
END;
sortIt(dataset(recfp) ds) := FUNCTION
    RETURN IF(Std.System.Thorlib.platform() = 'thor', PROJECT(SORT(ds, rfpos),removeFp(LEFT)), PROJECT(ds,removeFp(LEFT)));
END;

sequential(
    output(sortIt(fetched)),
    output(sortIt(fetched2)),
    output(sortIt(fetched3))
);
