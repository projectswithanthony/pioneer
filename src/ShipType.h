#ifndef _SHIPTYPE_H
#define _SHIPTYPE_H

#include "libs.h"
#include "vector3.h"
#include "EquipType.h"
#include "Serializer.h"
#include <vector>
#include <map>

struct lua_State;

struct ShipType {
	enum Thruster { THRUSTER_REVERSE, THRUSTER_FORWARD, THRUSTER_UP, THRUSTER_DOWN, THRUSTER_LEFT, THRUSTER_RIGHT, THRUSTER_MAX };
	enum { GUN_FRONT, GUN_REAR, GUNMOUNT_MAX = 2 };
	typedef std::string Type;

	////////
	std::string name;
	std::string lmrModelName;
	float linThrust[THRUSTER_MAX];
	float angThrust;
	struct GunMount {
		vector3f pos;
		vector3f dir;
	} gunMount[GUNMOUNT_MAX];
	int equipSlotCapacity[Equip::SLOT_MAX];
	int capacity; // tonnes
	int hullMass;
	int baseprice;
	Equip::Type hyperdrive;
	///////

	static std::string LADYBIRD;
	static std::string SIRIUS_INTERDICTOR;
	static std::string MISSILE_GUIDED;
	static std::string MISSILE_NAVAL;
	static std::string MISSILE_SMART;
	static std::string MISSILE_UNGUIDED;

	static Type GetRandomType();
	static std::map<Type, ShipType> types;
	static const char *gunmountNames[GUNMOUNT_MAX];
	static void Init();
	static const ShipType *Get(const char *name) {
		std::map<Type, ShipType>::iterator t = types.find(name);
		if (t == types.end()) return 0;
		else return &(*t).second;
	}
private:
	static int define_ship(lua_State *L, const char *model_name);
};

class EquipSet {
public:
	EquipSet() {}

	void InitSlotSizes(const ShipType::Type t) {
		for (int i=0; i<Equip::SLOT_MAX; i++) {
			equip[i] = std::vector<Equip::Type>(ShipType::types[t].equipSlotCapacity[i]);
		}
		onChange.emit();
	}
	int GetSlotSize(Equip::Slot s) const {
		return equip[s].size();
	}
	Equip::Type Get(Equip::Slot s) const {
		if (equip[s].size() == 0) return Equip::NONE;
		else return equip[s][0];
	}
	Equip::Type Get(Equip::Slot s, int idx) const {
		return equip[s][idx];
	}
	void Set(Equip::Slot s, int idx, Equip::Type e) {
		equip[s][idx] = e;
		onChange.emit();
	}
	bool Add(Equip::Type e, int num) {
		Equip::Slot s = EquipType::types[e].slot;
		int numDone = 0;
		for (unsigned int i=0; i<equip[s].size(); i++) {
			if (numDone == num) break;
			if (equip[s][i] == Equip::NONE) {
				equip[s][i] = e;
				numDone++;
			}
		}
		if (numDone) onChange.emit();
		return (numDone == num);
	}
	bool Add(Equip::Type e) {
		return Add(e, 1);
	}
	// returns number removed
	int Remove(Equip::Type e, int num) {
		Equip::Slot s = EquipType::types[e].slot;
		int numDone = 0;
		for (unsigned int i=0; i<equip[s].size(); i++) {
			if (num == 0) break;
			if (equip[s][i] == e) {
				equip[s][i] = Equip::NONE;
				num--;
				numDone++;
			}
		}
		onChange.emit();
		return numDone;
	}
	int Count(Equip::Slot s, Equip::Type e) const {
		int num = 0;
		for (unsigned int i=0; i<equip[s].size(); i++) {
			if (equip[s][i] == e) num++;
		}
		return num;
	}
	int FreeSpace(Equip::Slot s) const {
		int free = 0;
		for (unsigned int i=0; i<equip[s].size(); i++) {
			if (equip[s][i] == Equip::NONE) free++;
		}
		return free;
	}
	void Save(Serializer::Writer &wr);
	void Load(Serializer::Reader &rd);

	sigc::signal<void> onChange;
private:
	std::vector<Equip::Type> equip[Equip::SLOT_MAX];
};


#endif /* _SHIPTYPE_H */
