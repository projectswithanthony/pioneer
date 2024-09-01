-- Copyright © 2008-2024 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

-- Data source
-- https://forebears.io/iceland/forenames
-- https://forebears.io/iceland/surnames
-- https://www.nordicnames.de/wiki/List_of_approved_Icelandic_male_names
-- https://www.nordicnames.de/wiki/Category:Icelandic_Female_Names
-- Database of all approved names in Iceland: https://island.is/en/search-in-icelandic-names

-- used:
-- https://adventures.is/blog/icelandic-names/

local utils = require 'utils'
local CultureName = require './common'

local male = {
	"Aðalsteinn",
	"Andri",
	"Arnar",
	"Árni",
	"Ásgeir",
	"Atli",
	"Baldur",
	"Birgir",
	"Bjarni",
	"Björn",
	"Brynjar",
	"Daníel",
	"Egill",
	"Einar",
	"Eirík",
	"Eiríkur",
	"Friðrik",
	"Gísli",
	"Guðjón",
	"Guðmundur",
	"Guðni",
	"Gunnar",
	"Hafþór",
	"Halldór",
	"Haraldur",
	"Haukur",
	"Helgi",
	"Hrafn",
	"Ingi",
	"Ingólf",
	"Jóhann",
	"Jón",
	"Jónas",
	"Júlíus",
	"Kjartan",
	"Kristinn",
	"Kristján",
	"Magnús",
	"Ólafur",
	"Ólöf",
	"Páll",
	"Pétur",
	"Ragnar",
	"Rúnar",
	"Sævar",
	"Sigurður",
	"Snorri",
	"Sólhrafn",
	"Stefán",
	"Sturla",
	"Sveinn",
	"Sverrir",
	"Þórður",
	"Þorsteinn",
}

local female = {
	"Aðalsteinunn",
	"Ágústa",
	"Anna",
	"Arna",
	"Ása",
	"Ásdís",
	"Ásta",
	"Auður",
	"Berglind",
	"Björk",
	"Bryndís",
	"Brynhild",
	"Brynja",
	"Dagný",
	"Dóra",
	"Edda",
	"Elín",
	"Elísabet",
	"Embla",
	"Emma",
	"Erla",
	"Eva",
	"Guðbjörg",
	"Guðlaug",
	"Guðný",
	"Guðrún",
	"Halla",
	"Halldóra",
	"Harpa",
	"Hekla",
	"Helga",
	"Hildur",
	"Hjördís",
	"Hörður",
	"Hrafnhetta",
	"Hrafnhildur",
	"Hrefna",
	"Hulda",
	"Inga",
	"Ingibjörg",
	"Jóhanna",
	"Jóna",
	"Jónína",
	"Katla",
	"Katrín",
	"Kristín",
	"Kristjana",
	"Lára",
	"Lilja",
	"Margrét",
	"María",
	"Ragnheiður",
	"Rakel",
	"Sigríður",
	"Sigrún",
	"Steinunn",
	"Tinna",
	"Unnur",
	"Vigdís",
	"Þóra",
}

local surname = {
	"Aðalsteins{daughter}",
	"Ágústs{daughter}",
	"Árna{daughter}",
	"Arnar{daughter}",
	"Arnars{daughter}",
	"Ásgeirs{daughter}",
	"Baldurs{daughter}",
	"Benedikts{daughter}",
	"Birgis{daughter}",
	"Bjarna{daughter}",
	"Björgvins{daughter}",
	"Björk{daughter}",
	"Björks{daughter}",
	"Björns{daughter}",
	"Braga{daughter}",
	"Einars{daughter}",
	"Eiríks{daughter}",
	"Erlings{daughter}",
	"Friðriks{daughter}",
	"Gísla{daughter}",
	"Grétars{daughter}",
	"Guðjóns{daughter}",
	"Guðmunds{daughter}",
	"Guðna{daughter}",
	"Gunnars{daughter}",
	"Gunnlaugs{daughter}",
	"Hafsteins{daughter}",
	"Halldórs{daughter}",
	"Haralds{daughter}",
	"Harðar{daughter}",
	"Hauks{daughter}",
	"Helga{daughter}",
	"Hermanns{daughter}",
	"Hilmars{daughter}",
	"Indriða{daughter}",
	"Ingólfs{daughter}",
	"Jóhannes{daughter}",
	"Jóhanns{daughter}",
	"Jónas{daughter}",
	"Jons{daughter}",
	"Jóns{daughter}",
	"Karls{daughter}",
	"Kjartans{daughter}",
	"Kristins{daughter}",
	"Kristjáns{daughter}",
	"Laxness",
	"Magnús{daughter}",
	"Melax",
	"Ólafs{daughter}",
	"Örnólfs{daughter}",
	"Óskars{daughter}",
	"Páls{daughter}",
	"Péturs{daughter}",
	"Ragnars{daughter}",
	"Reynis{daughter}",
	"Rúnars{daughter}",
	"Sævars{daughter}",
	"Sigurðar{daughter}",
	"Sigurjóns{daughter}",
	"Skúla{daughter}",
	"Snorra{daughter}",
	"Stefáns{daughter}",
	"Svavars{daughter}",
	"Sveins{daughter}",
	"Sverris{daughter}",
	"Tryggva{daughter}",
	"Valdimars{daughter}",
	"Vilhjálms{daughter}",
	"Þórarins{daughter}",
	"Þórðar{daughter}",
	"Þóris{daughter}",
	"Þorsteins{daughter}",
}

local Icelandic = CultureName.New(
{
	male = male,
	female = female,
	surname = surname,
	name = "Icelandic",
	code = "is",
	replace = {
		['é'] = 'e', ['É'] = 'E',
		['þ'] = 'p', ['Þ'] = 'P',
		['ó'] = 'o', ['Ó'] = 'O',
		['ö'] = 'o', ['Ö'] = 'O',
		['í'] = 'i', ['Í'] = 'I',
		['ð'] = 'th', ['Ð'] = 'TH',
		['ú'] = 'u', ['Ú'] = 'U',
		['á'] = 'a', ['Á'] = 'A',
	}
})

-- Icelandic surnames are gender specific
function Icelandic:Surname (isFemale, rand, ascii)
	local lastname = utils.chooseEqual(self.surname, rand)

	-- Parent name ending with 'dóttir' for a daughter and 'son' for a son.
	local daughter = isFemale and "dóttir" or "son"

	return string.interp(lastname, { daughter = daughter })
end
return Icelandic
