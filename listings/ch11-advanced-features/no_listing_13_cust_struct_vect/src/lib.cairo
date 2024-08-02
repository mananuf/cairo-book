// ANCHOR: all

// ANCHOR: imports
use core::dict::Felt252Dict;
use core::nullable::{match_nullable, FromNullableResult, NullableTrait};
use core::integer;
// ANCHOR_END: imports

// ANCHOR: trait
trait VecTrait<V, T> {
    fn new() -> V;
    fn get(ref self: V, index: usize) -> Option<T>;
    fn at(ref self: V, index: usize) -> T;
    fn push(ref self: V, value: T) -> ();
    fn set(ref self: V, index: usize, value: T);
    fn len(self: @V) -> usize;
}
// ANCHOR_END: trait

// ANCHOR: struct
struct NullableVec<T> {
    data: Felt252Dict<Nullable<T>>,
    len: usize
}
// ANCHOR_END: struct

// ANCHOR: destruct
impl DestructNullableVec<T, +Drop<T>> of Destruct<NullableVec<T>> {
    fn destruct(self: NullableVec<T>) nopanic {
        self.data.squash();
    }
}
// ANCHOR_END: destruct

// ANCHOR: implem
impl NullableVecImpl<T, +Drop<T>, +Copy<T>> of VecTrait<NullableVec<T>, T> {
    fn new() -> NullableVec<T> {
        NullableVec { data: Default::default(), len: 0 }
    }

    fn get(ref self: NullableVec<T>, index: usize) -> Option<T> {
        if index < self.len() {
            Option::Some(self.data.get(index.into()).deref())
        } else {
            Option::None
        }
    }

    fn at(ref self: NullableVec<T>, index: usize) -> T {
        assert!(index < self.len(), "Index out of bounds");
        self.data.get(index.into()).deref()
    }

    fn push(ref self: NullableVec<T>, value: T) -> () {
        self.data.insert(self.len.into(), NullableTrait::new(value));
        self.len = core::integer::u32_wrapping_add(self.len, 1_usize);
    }
    // ANCHOR: set
    fn set(ref self: NullableVec<T>, index: usize, value: T) {
        assert!(index < self.len(), "Index out of bounds");
        self.data.insert(index.into(), NullableTrait::new(value));
    }
    // ANCHOR_END: set
    fn len(self: @NullableVec<T>) -> usize {
        *self.len
    }
}
// ANCHOR_END: implem


