exports.buildPlayerSummary = (data) => {
  return {
    tag: data.tag,
    name: data.name,
    level: data.expLevel,
    trophies: data.trophies,
    bestTrophies: data.bestTrophies,
    wins: data.wins,
    losses: data.losses,
    winRate: data.battleCount > 0 
      ? ((data.wins / data.battleCount) * 100).toFixed(2)
      : 0,
    clanName: data.clan?.name || "No Clan",
    clanTag: data.clan?.tag || null,
    arenaName: data.arena?.name || "Unknown Arena",
  };
};

exports.buildBattleSummary = (battle) => {
  const player = battle.team[0];
  const opponent = battle.opponent[0];

  return {
    battleTime: battle.battleTime,
    gameMode: battle.gameMode?.name,
    arenaName: battle.arena?.name,
    result:
      player.crowns > opponent.crowns ? "win" :
      player.crowns < opponent.crowns ? "lose" : "draw",
    playerCrowns: player.crowns,
    opponentCrowns: opponent.crowns,
    trophyChange: battle.trophyChange || 0,
    opponentName: opponent.name,
    opponentClan: opponent.clan?.name || "No Clan",
    playerDeck: player.cards.map(c => c.name),
    opponentDeck: opponent.cards.map(c => c.name),
  };
};
